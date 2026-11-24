import 'package:flutter/material.dart';

import '../Utils/AppColors.dart';

class Custommapformfield extends StatelessWidget {
  final String hinText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? Keyboardtype;
  final Widget? SuffixIcon;
  final Widget? prefixIcon;
  final FormFieldValidator? validator;
  final FocusNode? FocusNodes;
  const Custommapformfield({
    required this.hinText,
    this.isPassword = false,
    this.controller,
    this.FocusNodes,
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
        SizedBox(height: 6,),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: Keyboardtype,
          validator: validator,
          focusNode: FocusNodes,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: hinText,
              hintStyle: TextStyle(color: Colors.white38,fontSize: 14),
              filled: true,
              fillColor:Appcolors.Fieldbackcolor,
              suffixIcon: SuffixIcon,
              prefixIcon: prefixIcon,
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
