import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slope_net/Component/CustomTextButton.dart';
import 'package:slope_net/Component/CustomTextformField.dart';
import 'package:slope_net/Controller/AuthenticationController.dart';
import 'package:slope_net/Utils/AppColors.dart';
import 'package:slope_net/Utils/AppIcons.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final TextEditingController ForgotpasswordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  void _submit(){
    if(!_formkey.currentState!.validate()) return;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B131E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  spacing: 250,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
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
                         SizedBox(height: 20),
                        Container(
                          padding:  EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Appcolors.Fieldbackcolor, shape: BoxShape.circle),
                          child: const Icon(Icons.lock_outline, color: Colors.tealAccent, size: 28),
                        ),
                         SizedBox(height: 16),
                         Text("Forgot your password?", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                         SizedBox(height: 8),
                         Text("Enter the email you signed up with and we will send you a link to set a new password.", style: TextStyle(color: Colors.white60, fontSize: 14)),
                         SizedBox(height: 24),

                        Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              Customtextformfield(label: "Email address", hinText: "name@example.com",validator: (v)=>Authenticationcontroller.validateEmail(v??''),),
                            ],
                          ),
                        ),
                         SizedBox(height: 16),
                      ],
                    ),

                    Column(
                      children: [
                        CustomTextButton(
                          Textfield: "Send reset link",
                          onPressed: () {
                          _submit();
                          },
                          backgroundColor: Appcolors.buttonbackcolor,textColor: Appcolors.buttonTextcolor,),
                         SizedBox(height: 16),

                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child:  Text("Back to log in", style: TextStyle(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.w500)),
                          ),
                        ),
                         SizedBox(height: 20),
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
