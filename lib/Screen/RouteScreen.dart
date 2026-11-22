import 'package:flutter/material.dart';
import 'package:slope_net/Utils/AppColors.dart';

class Routescreen extends StatefulWidget {
  const Routescreen({super.key});

  @override
  State<Routescreen> createState() => _RoutescreenState();
}

class _RoutescreenState extends State<Routescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundcolor,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text("Route",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),) ,
                )
              ],
            ),
          )
      ),
    );
  }
}
