import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slope_net/Controller/AuthenticationController.dart';
import 'package:slope_net/Utils/AppIcons.dart';

import '../../Component/CustomTextButton.dart';
import '../../Component/CustomTextformField.dart';
import '../../Utils/AppColors.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final _formkey = GlobalKey<FormState>();

  final RxBool _obscurePassword = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _submit() {
    if (!_formkey.currentState!.validate()) return;

    // Agar validation pass ho jaye toh yahan apna signup logic likhein
    print("Name: ${nameController.text}");
    print("Email: ${emailController.text}");
    print("Password: ${passwordController.text}");
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundcolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(Appicons.backicon),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Create your account",
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Free for every traveler on the KKH and Skardu Road.",
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                    const SizedBox(height: 24),


                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Customtextformfield(
                            controller: nameController,
                            label: "Full name",
                            hinText: "Your name",
                            validator: (v) => (v == null || v.trim().isEmpty) ? "Please enter your full name" : null,
                          ),
                          const SizedBox(height: 16),
                          Customtextformfield(
                            controller: emailController,
                            label: "Email address",
                            hinText: "name@example.com",
                            Keyboardtype: TextInputType.emailAddress,
                            validator: (v) => Authenticationcontroller.validateEmail(v ?? ''),
                          ),
                          const SizedBox(height: 16),


                          Obx(
                                () => Customtextformfield(
                              controller: passwordController,
                              label: "Password",
                              hinText: "At least 8 characters",
                              isPassword: _obscurePassword.value,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "Please enter a password";
                                }
                                if (v.length < 8) {
                                  return "Password must be at least 8 characters";
                                }
                                return null;
                              },
                              SuffixIcon: IconButton(
                                onPressed: () {
                                  _obscurePassword.value = !_obscurePassword.value;
                                },
                                icon: Icon(
                                  _obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white38,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 140),


                    CustomTextButton(
                      Textfield: "Create account",
                      onPressed: _submit,
                      textColor: Appcolors.buttonTextcolor,
                      backgroundColor: Appcolors.buttonbackcolor,
                    ),
                     SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text("Already have an account? ", style: TextStyle(color: Colors.white60, fontSize: 13)),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child:  Text(
                            "Log in",
                            style: TextStyle(color: Colors.tealAccent, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}