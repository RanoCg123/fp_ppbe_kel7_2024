import 'package:flutter/material.dart';

class CreatePostTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final int maxLine;

  const CreatePostTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: maxLine > 1
          ? TextInputType.multiline
          : TextInputType.text,
      maxLines: maxLine,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),

      ),
    );
  }
}
