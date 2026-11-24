import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:slope_net/Controller/AuthenticationController.dart';
import 'package:slope_net/Controller/NotificationServicesController.dart';
import 'package:slope_net/Controller/RoleController.dart';
import 'package:slope_net/Screen/MapScreen.dart';
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
  await dotenv.load(fileName: "assets/config.env");
  final mapboxToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
  if (mapboxToken.isNotEmpty) {
    MapboxOptions.setAccessToken(mapboxToken);
  } else {
    debugPrint('Warning: MAPBOX_ACCESS_TOKEN is missing or empty in .env');
  }
  Get.put(RoleController(),permanent: true);

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