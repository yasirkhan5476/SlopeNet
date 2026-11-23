import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slope_net/Controller/AuthenticationController.dart';
import 'package:slope_net/Controller/NotificationServicesController.dart';
import 'package:slope_net/Screen/Splash_Screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Get.put(Authenticationcontroller(), permanent: true);

  final notifController = await Get.put(
    NotificationServicesController(),
    permanent: true,
  ).init();

  runApp(SlopeNetApp(notifController: notifController));
}

class SlopeNetApp extends StatelessWidget {
  final NotificationServicesController notifController;

  const SlopeNetApp({
    super.key,
    required this.notifController,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifController.handleInitialTerminatedMessage();
    });

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SlopeNet',
      home: SplashScreen(),
    );
  }
}