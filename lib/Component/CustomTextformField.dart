import 'package:flutter/material.dart';
import 'package:slope_net/Utils/AppColors.dart';

class Customtextformfield extends StatelessWidget {
  final String label;
  final String hinText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? Keyboardtype;
  final Widget? SuffixIcon;
  final Widget? prefixIcon;
  final FormFieldValidator? validator;
  const Customtextformfield({
    required this.label,
    required this.hinText,
    this.isPassword = false,
    this.controller,
    this.Keyboardtype,
    this.prefixIcon,
    this.SuffixIcon,
    this.validator,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,style: TextStyle(color: Colors.white24,fontSize: 13,fontWeight: FontWeight.w500),),
        SizedBox(height: 6,),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: Keyboardtype,
          validator: validator,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hinText,
            hintStyle: TextStyle(color: Colors.white38,fontSize: 14),
            filled: true,
            fillColor:Appcolors.Fieldbackcolor,
            suffixIcon: SuffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Appcolors.FieldBorder),

            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Appcolors.FieldBorder)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.teal,width: 1.5)
            )
          ),
        )
      ],
    );
  }
}
