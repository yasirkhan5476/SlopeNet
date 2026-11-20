import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class Maplocationcontroller extends GetxController {
  RxBool isLcoationReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkRequestPermission();
  }

  Future<void> checkRequestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Check karein ke GPS on hai ya nahi
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        "Location Disabled",
        "Please enable GPS/Location services.",
        duration: const Duration(seconds: 5),
        mainButton: TextButton(
          onPressed: () => Geolocator.openLocationSettings(),
          child: const Text("Open Settings", style: TextStyle(color: Colors.tealAccent)),
        ),
      );
      return;
    }

    // 2. Permissions check karein
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Permission Denied", "Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Permission Denied", "Location permissions are permanently denied.");
      return;
    }

    isLcoationReady.value = true;
  }
}