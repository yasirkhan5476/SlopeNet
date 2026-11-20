

import 'package:get/get.dart';

class Authenticationcontroller extends GetxController{
  static String? validateEmail(String value)=>RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())? null: "Enter a valid email";

}