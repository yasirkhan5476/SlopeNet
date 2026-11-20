import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:slope_net/Screen/Auth/Login_Screen.dart';
import 'package:slope_net/Screen/MapScreen.dart';

class Onboardingcontroller extends GetxController{
  var currIndex=0.obs;
  final PageController pageController = PageController();
  void onPageChange (int index){
    currIndex.value = index;
  }
  void nextPage(){
    if(currIndex.value<2){
      pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    else{
      Get.offAll(LoginScreen());
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}