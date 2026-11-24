import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slope_net/Component/CustomTextButton.dart';
import 'package:slope_net/Component/CustomTextformField.dart';
import 'package:slope_net/Utils/AppColors.dart';
import '../Controller/AuthenticationController.dart';
import '../Controller/RoleController.dart';

class RoleVerificationScreen extends StatelessWidget {
  RoleVerificationScreen({super.key});

  final RoleController controller = Get.put(RoleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundcolor,
      appBar: AppBar(
        backgroundColor: Appcolors.backgroundcolor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Role & verification",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Current Role Card
              Obx(
                    () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Appcolors.Fieldbackcolor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Appcolors.FieldBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "YOUR ROLE",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D2E24),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              controller.currentRole == UserRole.traveler ? "Default" : "Active",
                              style: const TextStyle(
                                color: Color(0xFF00E676),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.roleTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.roleDescription,
                        style: const TextStyle(color: Colors.white60, fontSize: 12.5, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // 2. Section Label
              const Text(
                "REQUEST HIGHER ACCESS",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),

              // 3. Field Responder / Volunteer Request Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Appcolors.Fieldbackcolor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Appcolors.FieldBorder),
                ),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text(
                              "Field Responder /\nVolunteer",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                            ),
                          ),
                          Obx(
                                () => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                controller.verificationStatus.value,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Priority incident reports with higher trust weight and road-clearance notes.",
                        style: TextStyle(color: Colors.white60, fontSize: 12.5, height: 1.4),
                      ),
                      const SizedBox(height: 16),

                      Customtextformfield(
                        controller: controller.orgController,
                        label: "Organization or volunteer group",
                        hinText: "Name of your organization",
                        validator: (v) => (v == null || v.trim().isEmpty) ? "Enter organization name" : null,
                      ),
                      const SizedBox(height: 14),

                      Customtextformfield(
                        controller: controller.credentialController,
                        label: "Credential or ID number",
                        hinText: "Credential number",
                        validator: (v) => (v == null || v.trim().isEmpty) ? "Enter credential number" : null,
                      ),
                      const SizedBox(height: 14),

                      // Attach Credential Photo Button
                      Obx(
                            () => SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Appcolors.FieldBorder),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                            ),
                            onPressed: controller.pickCredentialPhotoMock,
                            icon: Icon(
                              controller.attachedFileName.isEmpty
                                  ? Icons.camera_alt_outlined
                                  : Icons.check_circle_outline,
                              color: controller.attachedFileName.isEmpty
                                  ? Colors.white70
                                  : const Color(0xFF00E676),
                              size: 18,
                            ),
                            label: Text(
                              controller.attachedFileName.isEmpty
                                  ? "Attach credential photo"
                                  : controller.attachedFileName.value,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      CustomTextButton(
                        Textfield: "Submit for verification",
                        backgroundColor: Appcolors.buttonbackcolor,
                        textColor: Appcolors.buttonTextcolor,
                        onPressed: controller.submitRequest,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Appcolors.Fieldbackcolor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Appcolors.FieldBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.lock_outline, color: Colors.white54, size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Verified Authority / Moderator",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Set up by an administrator. Contact your department to request access.",
                            style: TextStyle(color: Colors.white54, fontSize: 12, height: 1.35),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
               SizedBox(height: 18),


            ],
          ),
        ),
      ),
    );
  }
}