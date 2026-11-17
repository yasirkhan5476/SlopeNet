import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slope_net/Controller/OnboardingController.dart';

import 'package:slope_net/Utils/AppColors.dart';

class OnBoardingpage extends StatelessWidget {
  const OnBoardingpage({super.key});

  @override
  Widget build(BuildContext context) {
    final Onboardingcontroller controller = Get.put(Onboardingcontroller());

    // Clean key-value list declaration (Dart automatically infers List>)
    final onboardingData = [
      {
        "title": "Predictive Landslide Intelligence",
        "subtitle": "Real-time rainfall and soil data score every stretch of road, so you know the risk before you reach it.",
      },
      {
        "title": "Real-Time Route Alerts",
        "subtitle": "Get instant notifications and alternative routes before hazardous weather hits the highway.",
      },
      {
        "title": "Offline Map Cache",
        "subtitle": "Stay connected and navigate safely through remote mountain passes even without cellular coverage.",
      },
    ];

    return Scaffold(
      backgroundColor: Appcolors.BlueColor,
      body: SafeArea(child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 24,vertical:16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset("assets/Icon/Slopenet2.png",width: 28,height: 28,),
                SizedBox(width: 8),
                const Text(
                  'SlopeNet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
            ),
            SizedBox(height: 24,),
            Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                    onPageChanged: controller.onPageChange,
                    itemCount: onboardingData.length,
                    itemBuilder: (context,index){
                    return Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 6),
                      child: Column(
                        children: [
                          Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Appcolors.onboard,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: Colors.white12,width: 1),

                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top:0,
                                      right: 0,
                                      child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Appcolors.softRed, width: 1.5),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text(
                                            'RISK INDEX',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            '78/100',
                                            style: TextStyle(
                                              color: Color(0xFFEF4444),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ),
                                    Center(
                                      child: Image.asset(
                                        'assets/Icon/Slopenet2.png',
                                        width: 90,
                                        height: 90,
                                      ),
                                    ),
                                  ],
                                ),
                          ),

                          ),
                          SizedBox(height: 36,),
                          Text(
                            onboardingData[index]["title"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),

                          ),
                           SizedBox(height: 12),

                          // Subtitle retrieved from the key-value list
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              onboardingData[index]["subtitle"]!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    }
                ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  onboardingData.length,
                  (index)=>Obx(()=>AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 6,
                    width: controller.currIndex.value == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: controller.currIndex.value == index
                          ? Appcolors.loadingbarColor
                          : Colors.white24,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ))
              ),

            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: controller.nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.loadingbarColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Color(0xFF09101D),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                  onPressed: (){},
                  child: Text(
                    'Continue as Guest',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ),
            )
          ],
        ),
          ),
      ),
    );
  }
}