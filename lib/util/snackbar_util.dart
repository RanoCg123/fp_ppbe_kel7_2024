import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content, {String? type}) {
  Color background = Colors.black45;
  if (type == "warning") {
    background = Colors.red;
  } else if (type == "success") {
    background = Colors.green;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: background,
      content: Text(
        content,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    ),
  );
}
