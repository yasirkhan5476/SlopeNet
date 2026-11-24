import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slope_net/Component/RiskBadgePill.dart';
import 'package:slope_net/Component/SlopeSurfaceCard.dart';
import 'package:slope_net/Controller/RoleController.dart';
import 'package:slope_net/Utils/AppColors.dart';

class AuthorityVerificationQueueScreen extends StatelessWidget {
  const AuthorityVerificationQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RoleController roleController = Get.find<RoleController>();

    if (!roleController.canAccessVerificationQueue) {
      return Scaffold(
        backgroundColor: Appcolors.backgroundcolor,
        appBar: AppBar(
          backgroundColor: Appcolors.backgroundcolor,
          foregroundColor: Colors.white,
          title: const Text('Verification Queue'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: SlopeSurfaceCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, color: Colors.redAccent, size: 36),
                  SizedBox(height: 10),
                  Text(
                    'Verified Authority Access Required',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Only Verified Authorities can review crowdsourced incidents and responder requests.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Appcolors.backgroundcolor,
        appBar: AppBar(
          backgroundColor: Appcolors.backgroundcolor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Verification queue',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Center(
                child: RiskBadgePill(
                  label: 'Authority',
                  color: Color(0xFF10B981),
                  icon: Icons.verified_user,
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Color(0xFF10B981),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: 'Incidents'),
              Tab(text: 'Role Requests'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _IncidentsModerationTab(roleController: roleController),
            _RoleRequestsTab(roleController: roleController),
          ],
        ),
      ),
    );
  }
}

class _IncidentsModerationTab extends StatelessWidget {
  final RoleController roleController;

  const _IncidentsModerationTab({required this.roleController});

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('incidents')
        .orderBy('createdAt', descending: true);

    return StreamBuilder<QuerySnapshot>(
    stream: query.snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF10B981)),
        );
      }

      final docs = snapshot.data?.docs ?? [];
      if (docs.isEmpty) {
        return const Center(
          child: Text(
            'No incident reports in queue.',
            style: TextStyle(color: Colors.white54),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: docs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final doc = docs[index];
          final data = (doc.data() as Map<String, dynamic>?) ?? {};
          final bool isVerified = data['verified'] == true;
          final String status =
          (data['moderationStatus'] ?? (isVerified ? 'verified' : 'pending'))
              .toString();
          final String title =
          (data['title'] ?? data['type'] ?? 'Slope Incident').toString();
          final String sector =
          (data['sector'] ?? 'Karakoram / Skardu Corridor').toString();
          final String description =
          (data['description'] ?? 'Reported along highway corridor.')
              .toString();
          final String reporterName =
          (data['reporterName'] ?? 'Traveler').toString();

          final Color badgeColor = isVerified
              ? const Color(0xFF22C55E)
              : (status == 'rejected' ? Colors.redAccent : Colors.amber);

          return SlopeSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    RiskBadgePill(
                      label: status.toUpperCase(),
                      color: badgeColor,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$sector · Reported by $reporterName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => roleController.setIncidentVerification(
                          incidentId: doc.id,
                          verified: false,
                          authorityNote: 'Rejected during authority review',
                        ),
                        icon: const Icon(Icons.close, size: 16),
                        label: const Text('Reject'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: BorderSide(
                            color: Colors.redAccent.withValues(alpha: 0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => roleController.setIncidentVerification(
                          incidentId: doc.id,
                          verified: true,
                          authorityNote: 'Verified on corridor',
                        ),
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text('Verify'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
    );
  }
}

class _RoleRequestsTab extends StatelessWidget {
  final RoleController roleController;

  const _RoleRequestsTab({required this.roleController});

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('role_requests')
        .where('status', isEqualTo: 'pending');

    return StreamBuilder<QuerySnapshot>(
    stream: query.snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF10B981)),
        );
      }

      final docs = snapshot.data?.docs ?? [];
      if (docs.isEmpty) {
        return const Center(
          child: Text(
            'No pending responder requests.',
            style: TextStyle(color: Colors.white54),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: docs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final doc = docs[index];
          final data = (doc.data() as Map<String, dynamic>?) ?? {};
          final String targetUid = (data['userId'] ?? doc.id).toString();
          final String userName =
          (data['userName'] ?? 'Applicant').toString();
          final String userEmail = (data['userEmail'] ?? '').toString();
          final String org =
          (data['organization'] ?? 'Field Unit').toString();
          final String note = (data['credentialNote'] ?? '').toString();

          return SlopeSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const RiskBadgePill(
                      label: 'PENDING',
                      color: Colors.amber,
                    ),
                  ],
                ),
                if (userEmail.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    userEmail,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  'Organization: $org',
                  style: const TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    note,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => roleController.reviewRoleRequest(
                          targetUserId: targetUid,
                          approve: false,
                          note: 'Credentials not verified',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: BorderSide(
                            color: Colors.redAccent.withValues(alpha: 0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Reject'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => roleController.reviewRoleRequest(
                          targetUserId: targetUid,
                          approve: true,
                          note: 'Verified Field Responder',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Approve Responder'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
    );
  }
}