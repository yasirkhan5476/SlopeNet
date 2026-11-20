import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
enum UserRole {
  traveler, fieldResponder, verifiedAuthority
}
class RoleController extends GetxController{
  final Rx<UserRole> currentRole = UserRole.traveler.obs;
  final RxString verificationStatus = "Not submitted".obs; // Not submitted | Pending | Verified
  final RxString attachedFileName = "".obs;

  // Form controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController orgController = TextEditingController();
  final TextEditingController credentialController = TextEditingController();

  final RxList<Map<String, String>> pendingRequests = [
  {
  "id": "1",
  "name": "Usman Tariq",
  "org": "Gilgit Rescue Volunteers",
  "credentialId": "GRV-2048",
  "submittedAt": "2h ago",
  },
  {
  "id": "2",
  "name": "Sanaullah Baig",
  "org": "Skardu Highway Patrol",
  "credentialId": "SHP-8812",
  "submittedAt": "5h ago",
  },
  ].obs;
  String get roleTitle {
    switch (currentRole.value) {
      case UserRole.traveler:
        return "Traveler / Commuter";
      case UserRole.fieldResponder:
        return "Field Responder / Volunteer";
      case UserRole.verifiedAuthority:
        return "Verified Authority / Moderator";
    }
  }
  String get roleDescription {
    switch (currentRole.value) {
      case UserRole.traveler:
        return "View risk maps, plan routes, get alerts, use SOS and submit reports that show as Unverified.";
      case UserRole.fieldResponder:
        return "Submit priority incident reports with higher trust weight and post road-clearance notes.";
      case UserRole.verifiedAuthority:
        return "Review responder credentials, verify community reports, and publish official route advisories.";
    }
  }

  void pickCredentialPhotoMock() {
    attachedFileName.value = "responder_id_card.jpg";
  }

  void submitRequest() {
    if (!formKey.currentState!.validate()) return;
    verificationStatus.value = "Pending";
    Get.snackbar(
      "Submitted",
      "Verification request saved locally. Connect Firebase to send for review.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void approveRequest(String id) {
    pendingRequests.removeWhere((item) => item["id"] == id);
  }

  void rejectRequest(String id) {
    pendingRequests.removeWhere((item) => item["id"] == id);
  }

  @override
  void onClose() {
    orgController.dispose();
    credentialController.dispose();
    super.onClose();
  }

}