import 'package:flutter/material.dart';
import 'package:fp_forum_kel7_ppbe/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData( 
        primaryColor: Color.fromRGBO(42, 91, 209, 1),
        fontFamily: 'Montserratcd'
      ),
      home: HomePage(),
    );
  }
}
