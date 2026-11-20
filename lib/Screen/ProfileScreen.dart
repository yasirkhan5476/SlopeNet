import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slope_net/Controller/ProfileCrontroller.dart';

import 'package:slope_net/Utils/AppColors.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundcolor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: "Profile" + Settings Gear
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Get.to(AppSettingsScreen()
                          },
                    icon:  Icon(Icons.settings_outlined, color: Colors.white70, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 18),


              Obx(
                    () => Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF172638),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Center(
                        child: Text(
                          controller.initials,
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                     SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.fullName.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            controller.email.value,
                            style:  TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color:  Color(0xFF0C2E24),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color:  Color(0xFF00E676).withOpacity(0.4)),
                            ),
                            child: Text(
                              controller.roleBadge.value,
                              style: TextStyle(
                                color: Color(0xFF00E676),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Role & Verification Tile
              _ProfileCard(
                onTap: controller.openRoleVerification,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text(
                            "Role & verification",
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Request Field Responder access",
                            style: TextStyle(color: Colors.white54, fontSize: 12.5),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white54),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Emergency Contacts Section
              const Text(
                "EMERGENCY CONTACTS",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              _ProfileCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0C2E24),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.phone_outlined, color: Color(0xFF00E676), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(
                                () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      controller.emergencyContactName.value,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0C2E24),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        "Primary",
                                        style: TextStyle(
                                          color: Color(0xFF00E676),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  controller.emergencyContactPhone.value,
                                  style: const TextStyle(color: Colors.white54, fontSize: 12.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => controller.openAddContactSheet(context),
                          icon: const Icon(Icons.edit_outlined, color: Colors.white54, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF00E676),
                          backgroundColor: const Color(0xFF0B1C22),
                          side: BorderSide(color: const Color(0xFF00E676).withOpacity(0.35)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => controller.openAddContactSheet(context),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text(
                          "Add emergency contact",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "SOS sends a pre-filled SMS with your exact GPS coordinates to your primary contact.",
                style: TextStyle(color: Colors.white54, fontSize: 12, height: 1.35),
              ),
              const SizedBox(height: 18),

              // Verification Queue Card (Authority Only)
              Obx(
                    () => Opacity(
                  opacity: controller.isVerifiedAuthority.value ? 1.0 : 0.85,
                  child: _ProfileCard(
                    onTap: controller.openVerificationQueue,
                    child: Row(
                      children: [
                        Icon(
                          controller.isVerifiedAuthority.value
                              ? Icons.verified_user_outlined
                              : Icons.lock_outline,
                          color: controller.isVerifiedAuthority.value
                              ? const Color(0xFF00E676)
                              : Colors.white54,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Verification queue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Shown only to Verified Authority accounts",
                                style: TextStyle(color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.white54),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _ProfileCard({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Appcolors.Fieldbackcolor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Appcolors.FieldBorder),
        ),
        child: child,
      ),
    );
  }
}