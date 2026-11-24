import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slope_net/Component/RiskBadgePill.dart';
import 'package:slope_net/Component/SlopeSurfaceCard.dart';
import 'package:slope_net/Controller/AuthenticationController.dart';
import 'package:slope_net/Controller/RoleController.dart';
import 'package:slope_net/Screen/AuthorityVerificationQueueScreen.dart';
import 'package:slope_net/Utils/AppColors.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  final Authenticationcontroller authController =
  Get.find<Authenticationcontroller>();
  final RoleController roleController = Get.find<RoleController>();

  bool geofenceAlertsEnabled = true;
  bool batterySaverGps = true;
  bool lowBandwidthMode = false;

  void _openResponderRequestDialog() {
    final orgController = TextEditingController();
    final noteController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF131A24),
        title: const Text(
          'Request Field Responder Role',
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: orgController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Organization / Rescue Team',
                labelStyle: TextStyle(color: Colors.white54),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: noteController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Badge / ID / Duty Note',
                labelStyle: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await roleController.requestFieldResponderRole(
                orgName: orgController.text,
                credentialNote: noteController.text,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.black,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundcolor,
      appBar: AppBar(
        backgroundColor: Appcolors.backgroundcolor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'App settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final role = roleController.currentRole;
          final status = roleController.verificationStatus.value;

          Color roleColor = Colors.lightBlueAccent;
          if (role == UserRole.verifiedAuthority) {
            roleColor = const Color(0xFF22C55E);
          } else if (role == UserRole.fieldResponder) {
            roleColor = Colors.amber;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account & RBAC Role Card
              SlopeSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authController.userName.value.isEmpty
                                    ? 'SlopeNet User'
                                    : authController.userName.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                authController.userEmail.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        RiskBadgePill(
                          label: role.displayLabel,
                          color: roleColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Verification status: ${status.toUpperCase()}',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                    if (role == UserRole.traveler && status != 'pending') ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _openResponderRequestDialog,
                          icon: const Icon(Icons.badge_outlined, size: 18),
                          label: const Text('Request Field Responder Access'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.amber,
                            side: BorderSide(
                              color: Colors.amber.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (roleController.canAccessVerificationQueue) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Get.to(
                                () => const AuthorityVerificationQueueScreen(),
                          ),
                          icon: const Icon(Icons.admin_panel_settings, size: 18),
                          label: const Text('Open Authority Verification Queue'),
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
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'ALERTS & CORRIDOR TELEMETRY',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              SlopeSurfaceCard(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: geofenceAlertsEnabled,
                      activeThumbColor: const Color(0xFF10B981),
                      title: const Text(
                        '10 km Geofence Hazard Alerts',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      subtitle: const Text(
                        'Warn before entering active landslide zones',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      onChanged: (v) => setState(() => geofenceAlertsEnabled = v),
                    ),
                    const Divider(color: Colors.white10, height: 1),
                    SwitchListTile(
                      value: batterySaverGps,
                      activeThumbColor: const Color(0xFF10B981),
                      title: const Text(
                        'Adaptive GPS Polling',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      subtitle: const Text(
                        'Reduce GPS sampling when stationary',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      onChanged: (v) => setState(() => batterySaverGps = v),
                    ),
                    const Divider(color: Colors.white10, height: 1),
                    SwitchListTile(
                      value: lowBandwidthMode,
                      activeThumbColor: const Color(0xFF10B981),
                      title: const Text(
                        'Low-Bandwidth Mode (2G/3G)',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      subtitle: const Text(
                        'Minimize background telemetry payload size',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      onChanged: (v) => setState(() => lowBandwidthMode = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => authController.logout(),
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('Sign Out'),
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