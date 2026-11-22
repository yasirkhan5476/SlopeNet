import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slope_net/Controller/AuthenticationController.dart';
import 'package:slope_net/Utils/AppColors.dart';

class VerifyEmailScreen extends StatelessWidget {
  VerifyEmailScreen({super.key});

  final Authenticationcontroller authController =
  Get.isRegistered<Authenticationcontroller>()
      ? Get.find<Authenticationcontroller>()
      : Get.put(Authenticationcontroller(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundcolor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Email Verification Icon Badge
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: const Color(0xFF0C2E24),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF00E676).withOpacity(0.4),
                  ),
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  color: Color(0xFF00E676),
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                "Verify your email",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle with User's Email
              Obx(
                    () => RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: "We sent a verification link to\n",
                      ),
                      TextSpan(
                        text: authController.userEmail.value.isNotEmpty
                            ? authController.userEmail.value
                            : "your email address",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(
                        text:
                        "\n\nOpen your inbox (or spam folder), click the link, and tap the button below.",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Primary Button: I've Verified My Email
              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: authController.isLoading.value
                        ? null
                        : () => authController.checkEmailVerified(),
                    child: authController.isLoading.value
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.black,
                      ),
                    )
                        : const Text(
                      "I've Verified My Email",
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Secondary Button: Resend Verification Email with 60s Cooldown
              Obx(() {
                final seconds = authController.resendSecondsLeft.value;
                final isDisabled =
                    authController.isLoading.value || seconds > 0;

                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Appcolors.Fieldbackcolor,
                      side: BorderSide(color: Appcolors.FieldBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: isDisabled
                        ? null
                        : () => authController.resendVerificationEmail(),
                    icon: const Icon(Icons.refresh, size: 19),
                    label: Text(
                      seconds > 0
                          ? "Resend email in ${seconds}s"
                          : "Resend verification email",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),

              const Spacer(),

              // Footer: Use a Different Account
              TextButton(
                onPressed: () => authController.logout(),
                child: const Text(
                  "Wrong email? Sign out and try another",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}