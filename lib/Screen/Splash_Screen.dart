import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:slope_net/Controller/SplashController.dart';
import 'package:slope_net/Utils/AppAnimations.dart';
import 'package:slope_net/Utils/AppColors.dart';
import 'package:slope_net/Utils/AppIcons.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Register and initialize the controller
    final SplashController controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: Appcolors.BlueColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // 1. Lottie Animation
              SizedBox(
                width: 140,
                height: 140,
                child: Lottie.asset(
                  Appanimations.AppAnimate,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
              const SizedBox(height: 40),

              // 2. Static Branding & Info
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D233A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12, width: 1),
                    ),
                    child: Image.asset(
                      Appicons.Logoicon,
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'SlopeNet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Predictive landslide intelligence for the Karakoram Highway and Skardu Road',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // 3. Loading Status Text at the bottom
              // 3. Cropped Loading Bar + Tight Text Grouping
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 6,
                    child: LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.white.withValues(alpha:0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Appcolors.loadingbarColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Preparing offline map cache',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}