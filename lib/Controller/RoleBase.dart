import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
enum UserRole {
  traveler, fieldResponder, verifiedAuthority
}
class Rolebase extends GetxController{
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

}