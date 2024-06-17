import 'package:flutter/material.dart';

class OwnPostPage extends StatefulWidget {
  const OwnPostPage({super.key});

  @override
  State<OwnPostPage> createState() => _OwnPostPageState();
}

class _OwnPostPageState extends State<OwnPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.black,
                      )),
                  SizedBox(width: 5.0),
                  Text(
                    "My Post",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
