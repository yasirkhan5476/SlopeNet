import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slope_net/Component/CustomTextButton.dart';
import 'package:slope_net/Component/CustomTextformField.dart';
import 'package:slope_net/Controller/AuthenticationController.dart';
import 'package:slope_net/Screen/Auth/Forgotpassword.dart';
import 'package:slope_net/Screen/Auth/SignupScreen.dart';
import 'package:slope_net/Screen/MapScreen.dart';
import 'package:slope_net/Screen/RootScreen.dart';
import 'package:slope_net/Utils/AppColors.dart';
import 'package:slope_net/Utils/AppIcons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final RxBool _obscurePassword = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;
  final Authenticationcontroller AuthController = Get.put(Authenticationcontroller());
  void _submit(){
    if(!_formkey.currentState!.validate()) return;
    String email = emailController.text;
    String password = passwordController.text;
    AuthController.loginWithEmail(email: email, password: password);
  }
  @override
  void dispose() {
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
                padding:  EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      spacing: 110,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color:   Color(0xFF0D233A),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Image.asset(
                                    Appicons.Logoicon,
                                    width: 32,
                                    height: 32,
                                  ),
                                ),
                                  SizedBox(width: 8),
                                  Text("SlopeNet", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),

                              ],
                            ),
                            SizedBox(height: 30),
                            Text("Welcome back", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                            SizedBox(height: 8),
                            Text("Log in to see live landslide risk on your route.", style: TextStyle(color: Colors.white60, fontSize: 14)),
                            SizedBox(height: 24),

                          Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                Customtextformfield(
                                  label: "Email address",
                                  hinText: "name@example.com",
                                  controller: emailController,
                                  Keyboardtype: TextInputType.emailAddress,
                                  validator: (v)=>Authenticationcontroller.validateEmail(v??''),),
                                SizedBox(height: 16),
                                Obx(()=> Customtextformfield(
                                  label: "Password",
                                  hinText: "Enter your password",
                                  controller: passwordController,
                                  isPassword: _obscurePassword.value,
                                  validator: (v)=>(v??"").isEmpty ?"Enter the password":null,
                                  SuffixIcon: IconButton(
                                    onPressed: (){_obscurePassword.value=!_obscurePassword.value;},
                                    icon: Icon(_obscurePassword.value?Icons.visibility_off:Icons.visibility),
                                    color: Colors.white38,),
                                ),
                                ),
                              ],
                            ),
                          ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Get.to(Forgotpassword());
                                },
                                child: Text("Forgot password?", style: TextStyle(color: Colors.tealAccent, fontSize: 13)),
                              ),
                            ),
                             SizedBox(height: 24),
                            Obx(
                                  ()=>
                                  CustomTextButton(
                                    Textfield: AuthController.isLoading.value?"Logging in":"Login",
                                    onPressed: AuthController.isLoading.value?(){}:(){
                                      _submit();
                                    },
                                    backgroundColor: Appcolors.buttonbackcolor,
                                    textColor: Appcolors.buttonTextcolor,
                                  ),
                            ),
                             SizedBox(height: 12),
                            Obx(
                                  () => OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 50),
                                  side: BorderSide(color: Appcolors.FieldBorder),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: AuthController.isLoading.value
                                    ? null
                                    : () => AuthController.signInWithGoogle(),
                                icon:  Icon(Icons.g_mobiledata, color: Colors.white, size: 28),
                                label: Text(
                                  "Continue with Google",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Column(
                          children: [

                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Text("New to SlopeNet? ", style: TextStyle(color: Colors.white60, fontSize: 13)),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(Signupscreen());
                                  },
                                  child:  Text("Create account", style: TextStyle(color: Colors.tealAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
            ),
          )
      ),
    );
  }
}
