import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:slope_net/Screen/Auth/Login_Screen.dart';
import 'package:slope_net/Screen/MapScreen.dart';
import 'package:slope_net/Screen/RootScreen.dart';
import 'package:slope_net/Screen/Splash_Screen.dart';
import 'package:slope_net/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: "assets/config.env");
  final mapboxToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
  MapboxOptions.setAccessToken(mapboxToken);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Slope Net',
      theme: ThemeData(
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  SplashScreen(),
    );
  }
}
