import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slope_net/Controller/AuthenticationController.dart';

class RoleController extends GetxController{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Authenticationcontroller _authController = Get.find<Authenticationcontroller>();


  final RxString verificationStatus = "Not submitted".obs; // Not submitted | Pending | Verified
  final RxString attachedFileName = "".obs;
  final RxString organization = ''.obs;
  final RxBool isSubmitting = false.obs;

  UserRole get currentRole => _authController.userRole.value;
  bool get isVerifiedAuthority => _authController.isVerifiedAuthority;
  bool get isFieldResponder => _authController.isFieldResponder;

  StreamSubscription<DocumentSnapshot>? _userSub;
  // Permission getters aligned with SlopeNet SRS
  bool get canSubmitIncident => _authController.firebaseUser.value != null;
  bool get canSubmitFieldReport => isFieldResponder;
  bool get canAccessVerificationQueue => isVerifiedAuthority;
  bool get canVerifyIncidents => isVerifiedAuthority;
  bool get canManageSegmentStatus => isVerifiedAuthority;
  bool get canPublishAdvisory => isVerifiedAuthority;

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
    switch (currentRole) {
      case UserRole.traveler:
        return "Traveler / Commuter";
      case UserRole.fieldResponder:
        return "Field Responder / Volunteer";
      case UserRole.verifiedAuthority:
        return "Verified Authority / Moderator";
    }
  }
  String get roleDescription {
    switch (currentRole) {
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
  @override
  void onInit() {
    super.onInit();
    _bindCurrentUserStream();
    ever(_authController.firebaseUser, (_) => _bindCurrentUserStream());
  }
  void _bindCurrentUserStream(){
    _userSub?.cancel();
    final uid = _authController.firebaseUser.value?.uid;
    if(uid == null){
      verificationStatus.value="none";
      organization.value='';
      return;
    }
    _userSub = _db.collection("users").doc(uid).snapshots().listen((snap){
      final data = snap.data();
      if(data==null){
        _authController.userRole.value =
            UserRole.fromString(data?['role']?.toString());
        verificationStatus.value =
            (data?['verificationStatus'] ?? 'none').toString();
        organization.value = (data?['organization'] ?? '').toString();
      }
    });
  }
  Future<void> requestFieldResponderRole({
    required String orgName,
    required String credentialNote,
  }) async {
    final user = _authController.firebaseUser.value;
    if (user == null) return;

    if (orgName.trim().isEmpty || credentialNote.trim().isEmpty) {
      _notify('Missing Details', 'Please enter your organization and credentials.');
      return;
    }

    try {
      isSubmitting.value = true;

      await _db.collection('role_requests').doc(user.uid).set({
        'userId': user.uid,
        'userName': _authController.userName.value,
        'userEmail': _authController.userEmail.value,
        'requestedRole': UserRole.fieldResponder.firestoreValue,
        'organization': orgName.trim(),
        'credentialNote': credentialNote.trim(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _db.collection('users').doc(user.uid).set({
        'verificationStatus': 'pending',
        'organization': orgName.trim(),
      }, SetOptions(merge: true));

      _notify(
        'Request Submitted',
        'Your Field Responder verification request is pending authority review.',
      );
    } catch (e) {
      _notify('Error', 'Could not submit request: $e', isError: true);
    } finally {
      isSubmitting.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // B. AUTHORITY SERVICE 1: APPROVE / REJECT ROLE REQUEST
  // ---------------------------------------------------------------------------
  Future<void> reviewRoleRequest({
    required String targetUserId,
    required bool approve,
    String? note,
  }) async {
    if (!canAccessVerificationQueue) {
      _notify('Unauthorized', 'Only Verified Authorities can review requests.',
          isError: true);
      return;
    }

    final reviewerId = _authController.firebaseUser.value?.uid;

    try {
      isSubmitting.value = true;
      final batch = _db.batch();

      final requestRef = _db.collection('role_requests').doc(targetUserId);
      final userRef = _db.collection('users').doc(targetUserId);

      batch.update(requestRef, {
        'status': approve ? 'approved' : 'rejected',
        'reviewNote': note?.trim() ?? '',
        'reviewedBy': reviewerId,
        'reviewedAt': FieldValue.serverTimestamp(),
      });

      batch.update(userRef, {
        'role': approve
            ? UserRole.fieldResponder.firestoreValue
            : UserRole.traveler.firestoreValue,
        'verificationStatus': approve ? 'approved' : 'rejected',
        'verifiedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      _notify(
        approve ? 'Role Approved' : 'Request Rejected',
        approve
            ? 'User upgraded to Field Responder.'
            : 'Verification request marked as rejected.',
      );
    } catch (e) {
      _notify('Error', 'Failed to update role request: $e', isError: true);
    } finally {
      isSubmitting.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // C. AUTHORITY SERVICE 2: VERIFY / REJECT INCIDENT REPORT
  // ---------------------------------------------------------------------------
  Future<void> setIncidentVerification({
    required String incidentId,
    required bool verified,
    String? authorityNote,
  }) async {
    if (!canVerifyIncidents) {
      _notify('Unauthorized', 'Only Verified Authorities can verify incidents.',
          isError: true);
      return;
    }

    try {
      await _db.collection('incidents').doc(incidentId).update({
        'verified': verified,
        'moderationStatus': verified ? 'verified' : 'rejected',
        'authorityNote': authorityNote?.trim() ?? '',
        'verifiedBy': _authController.firebaseUser.value?.uid,
        'verifiedAt': FieldValue.serverTimestamp(),
      });

      _notify(
        verified ? 'Incident Verified' : 'Incident Rejected',
        'Incident status updated on map.',
      );
    } catch (e) {
      _notify('Error', 'Could not update incident: $e', isError: true);
    }
  }

  // ---------------------------------------------------------------------------
  // D. AUTHORITY SERVICE 3: UPDATE CORRIDOR SEGMENT STATUS
  // ---------------------------------------------------------------------------
  Future<void> updateSegmentStatus({
    required String segmentId,
    required String status, // 'safe' | 'moderate' | 'blocked'
    required int riskScore,
  }) async {
    if (!canManageSegmentStatus) {
      _notify(
        'Unauthorized',
        'Only Verified Authorities can update corridor segment status.',
        isError: true,
      );
      return;
    }

    try {
      await _db.collection('corridor_segments').doc(segmentId).set({
        'status': status,
        'riskScore': riskScore,
        'updatedBy': _authController.firebaseUser.value?.uid,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _notify('Segment Updated', 'Segment marked as $status ($riskScore/100).');
    } catch (e) {
      _notify('Error', 'Could not update segment: $e', isError: true);
    }
  }

  // ---------------------------------------------------------------------------
  // E. AUTHORITY SERVICE 4: PUBLISH REGIONAL HAZARD ADVISORY
  // ---------------------------------------------------------------------------
  Future<void> publishAdvisory({
    required String title,
    required String body,
    required String sector,
    required String severity, // 'moderate' | 'high' | 'critical'
  }) async {
    if (!canPublishAdvisory) {
      _notify('Unauthorized', 'Only Verified Authorities can publish advisories.',
          isError: true);
      return;
    }

    try {
      await _db.collection('advisories').add({
        'title': title.trim(),
        'body': body.trim(),
        'sector': sector.trim(),
        'severity': severity.trim(),
        'publishedBy': _authController.firebaseUser.value?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _notify('Advisory Published', 'Regional hazard advisory is now live.');
    } catch (e) {
      _notify('Error', 'Could not publish advisory: $e', isError: true);
    }
  }

  void _notify(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError
          ? Colors.redAccent.withValues(alpha: 0.92)
          : const Color(0xFF0C2E24),
      colorText: Colors.white,
    );
  }

}