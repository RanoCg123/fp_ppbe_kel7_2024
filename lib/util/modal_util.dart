import 'package:flutter/material.dart';

class Option {
  final String text;
  final IconData icon;
  final Function() handler;

  const Option({required this.text, required this.icon, required this.handler});
}

void showBottomOptionModal(
  BuildContext context,
  List<Option> options,
  double height,
) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: height,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map((option) => GestureDetector(
                      onTap: option.handler,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 20.0,
                        ),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(option.icon),
                            const SizedBox(width: 20.0,),
                            Text(
                              option.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      );
    },
  );
}
