import 'package:flutter/material.dart';

class CreatePostButton extends StatelessWidget {
  final Function()? onTap;
  final String textButton;

  const CreatePostButton(this.textButton, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 53, 114, 239),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            textButton,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}