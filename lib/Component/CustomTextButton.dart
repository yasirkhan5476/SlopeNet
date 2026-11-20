import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String Textfield;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  const CustomTextButton({
    required this.Textfield,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
          onPressed: onPressed,
          child: Text(Textfield,style: TextStyle(color: textColor,fontSize: 16,fontWeight: FontWeight.bold),)),
    );
  }
}
