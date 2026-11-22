import 'package:get/get.dart';
import 'package:slope_net/Controller/AuthenticationController.dart';
import 'package:slope_net/Screen/OnBoardingpage.dart';

class SplashController extends GetxController {
  var showBranding = false.obs;

  @override
  void onInit() {
    super.onInit();
    _handleSplashNavigation();
  }

  Future<void> _handleSplashNavigation() async {
    final Authenticationcontroller authController =
    Get.isRegistered<Authenticationcontroller>()
        ? Get.find<Authenticationcontroller>()
        : Get.put(Authenticationcontroller(), permanent: true);

    await Future.wait([
      _runBrandingSequence(),
      _waitForAuthReady(authController),
    ]);

    await authController.routeBySavedSession(
      fallbackScreen: OnBoardingpage(),
    );
  }

  Future<void> _runBrandingSequence() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    showBranding.value = true;
    await Future.delayed(const Duration(seconds: 4));
  }

  Future<void> _waitForAuthReady(Authenticationcontroller authController) async {
    if (authController.isAuthReady.value) return;
    await authController.isAuthReady.stream.firstWhere((ready) => ready == true);
  }
}