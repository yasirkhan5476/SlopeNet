import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Component/CustomTextformField.dart';


class ProfileController extends GetxController {
  final RxString fullName = "Ali Hassan".obs;
  final RxString email = "ali@example.com".obs;
  final RxString roleBadge = "Traveler".obs;
  final RxString emergencyContactName = "Family contact".obs;
  final RxString emergencyContactPhone = "+92 3XX XXXXXXX".obs;

  // Toggle to true when testing Verified Authority access
  final RxBool isVerifiedAuthority = false.obs;

  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();

  String get initials {
    final parts = fullName.value.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return "U";
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return "${parts.first[0]}${parts.last[0]}".toUpperCase();
  }

  void openRoleVerification() {
    // Get.to(() => RoleVerificationScreen());
  }

  void openVerificationQueue() {
    if (!isVerifiedAuthority.value) {
      Get.snackbar(
        "Authority Access Required",
        "Verification queue is shown only to Verified Authority accounts.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    // Get.to(() => VerificationQueueScreen());
  }

  void openAddContactSheet(BuildContext context) {
    contactNameController.clear();
    contactPhoneController.clear();

    Get.bottomSheet(
      Container(
        padding:  EdgeInsets.all(20),
        decoration:  BoxDecoration(
          color: Color(0xFF101924),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add emergency contact",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),

            Customtextformfield(controller: contactNameController, label: "Contact label", hinText: "e.g. Father / Brother"),
            const SizedBox(height: 12),
            Customtextformfield(controller: contactPhoneController, label: "Phone number", hinText: "+92 3XX XXXXXXX", Keyboardtype: TextInputType.phone),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E676),
                  foregroundColor: const Color(0xFF07131B),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {

                },
                child: const Text("Save contact", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onClose() {
    contactNameController.dispose();
    contactPhoneController.dispose();
    super.onClose();
  }
}