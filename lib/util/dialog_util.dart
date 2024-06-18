import 'package:flutter/material.dart';

void showDeletePostDialog(
  BuildContext context, {
  required String content,
  required Function() handler,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(content),
        // content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: handler,
            child: const Text(
              'Yes',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'No',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    },
  );
}
