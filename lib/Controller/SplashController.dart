import 'package:get/get.dart';
import 'package:slope_net/Controller/OnboardingController.dart';
import 'package:slope_net/Screen/Auth/Login_Screen.dart';
import 'package:slope_net/Screen/OnBoardingpage.dart';

class SplashController extends GetxController{
  var showBranding = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _gotToLogin();
  }
  void _gotToLogin() async{
    await Future.delayed(const Duration(milliseconds: 1500));
    showBranding.value = true;
   await Future.delayed(Duration(seconds: 4));
    Get.offAll(OnBoardingpage());
  }
}