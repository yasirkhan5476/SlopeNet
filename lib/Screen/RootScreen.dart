import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slope_net/Screen/MapScreen.dart';
import 'package:slope_net/Screen/ProfileScreen.dart';
import 'package:slope_net/Screen/RouteScreen.dart';
import 'package:slope_net/Utils/AppColors.dart';

import 'AlertScreen.dart';
import 'RoutePlannerScreen.dart';
// Make sure to import Mapscreen and ProfileScreen here

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class BottomController extends GetxController {
  final RxInt index = 0.obs;

  void changeTab(int tabIndex) {
    index.value = tabIndex;
  }
}

class _RootScreenState extends State<RootScreen> {
  final BottomController bottomController = Get.put(BottomController());

  late final List<Widget> _screens = [
    Mapscreen(),
    RoutePlannerScreen(),
    AlertsFeedScreen(),
     _TabPlaceholder(title: "Offline", icon: Icons.download_outlined),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Adjusted so your white placeholder text is visible
      body: Obx(() => IndexedStack(
        index: bottomController.index.value,
        children: _screens,
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: bottomController.index.value,
        onTap: bottomController.changeTab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Appcolors.bottomColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alt_route),
            label: 'Route',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_outlined),
            label: 'Offline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      )),
    );
  }

  Widget _TabPlaceholder({required String title, required IconData icon}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Appcolors.bottomColor, size: 42),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
