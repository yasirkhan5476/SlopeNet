import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slope_net/Component/RiskBadgePill.dart';
import 'package:slope_net/Component/SlopeSurfaceCard.dart';
import 'package:slope_net/Controller/AuthenticationController.dart';
import 'package:slope_net/Controller/RoleController.dart';
import 'package:slope_net/Screen/AppSettingsScreen.dart';
import 'package:slope_net/Screen/AuthorityVerificationQueueScreen.dart';
import 'package:slope_net/Utils/AppColors.dart';

class ProfileScreen extends StatelessWidget {
    ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Authenticationcontroller authController =
    Get.find<Authenticationcontroller>();
    final RoleController roleController = Get.find<RoleController>();

    return Scaffold(
      backgroundColor: Appcolors.backgroundcolor,
      appBar: AppBar(
        backgroundColor: Appcolors.backgroundcolor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title:   Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon:   Icon(Icons.settings_outlined),
            onPressed: () => Get.to(() =>   AppSettingsScreen()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding:   EdgeInsets.all(16),
        child: Obx(() {
          final String name = authController.userName.value.trim().isNotEmpty
              ? authController.userName.value.trim()
              : (authController.firebaseUser.value?.displayName ??
              'SlopeNet User');
          final String email = authController.userEmail.value.trim().isNotEmpty
              ? authController.userEmail.value.trim()
              : (authController.firebaseUser.value?.email ?? 'No email');
          final UserRole role = authController.userRole.value;
          final String verificationStatus =
              roleController.verificationStatus.value;

          final Color roleColor = switch (role) {
            UserRole.verifiedAuthority =>   Color(0xFF22C55E),
            UserRole.fieldResponder => Colors.amber,
            UserRole.traveler => Colors.lightBlueAccent,
          };

          final String initial =
          name.isNotEmpty ? name[0].toUpperCase() : 'S';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logged-in User Identity Card (Name, Email, Role)
              SlopeSurfaceCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: roleColor.withValues(alpha: 0.18),
                          child: Text(
                            initial,
                            style: TextStyle(
                              color: roleColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                          SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:   TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                                SizedBox(height: 3),
                              Text(
                                email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:   TextStyle(
                                  color: Colors.white60,
                                  fontSize: 13,
                                ),
                              ),
                                SizedBox(height: 8),
                              RiskBadgePill(
                                label: role.displayLabel,
                                color: roleColor,
                                icon: role == UserRole.verifiedAuthority
                                    ? Icons.verified_user
                                    : (role == UserRole.fieldResponder
                                    ? Icons.shield_outlined
                                    : Icons.person_outline),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                      SizedBox(height: 14),
                      Divider(color: Colors.white10, height: 1),
                      SizedBox(height: 12),
                    _InfoRow(
                      label: 'Assigned Role',
                      value: role.displayLabel,
                      valueColor: roleColor,
                    ),
                      SizedBox(height: 8),
                    _InfoRow(
                      label: 'Verification Status',
                      value: verificationStatus.toUpperCase(),
                      valueColor: Colors.white70,
                    ),
                    if (roleController.organization.value.isNotEmpty) ...[
                        SizedBox(height: 8),
                      _InfoRow(
                        label: 'Organization',
                        value: roleController.organization.value,
                        valueColor: Colors.white70,
                      ),
                    ],
                  ],
                ),
              ),
                SizedBox(height: 16),

              // Role-based quick actions
              if (roleController.canAccessVerificationQueue) ...[
                SlopeSurfaceCard(
                  onTap: () => Get.to(
                        () =>   AuthorityVerificationQueueScreen(),
                  ),
                  child:   Row(
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        color: Color(0xFF10B981),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Authority Verification Queue',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Review incident reports & responder requests',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white54),
                    ],
                  ),
                ),
                  SizedBox(height: 12),
              ],

              SlopeSurfaceCard(
                onTap: () => Get.to(() => AppSettingsScreen()),
                child:   Row(
                  children: [
                    Icon(Icons.tune, color: Colors.lightBlueAccent),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Role Verification & App Settings',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Manage role upgrade, alerts & telemetry',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.white54),
                  ],
                ),
              ),
                SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => authController.logout(),
                  icon:   Icon(Icons.logout, size: 18),
                  label:   Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: BorderSide(
                      color: Colors.redAccent.withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

    _InfoRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:   TextStyle(color: Colors.white54, fontSize: 12.5),
        ),
          SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}