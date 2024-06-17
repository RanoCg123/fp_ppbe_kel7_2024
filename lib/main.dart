import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import '../screens/main_screen.dart';
import '../screens/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: const Color.fromRGBO(42, 91, 209, 1),
          fontFamily: 'Montserratcd'
      ),
      // home: const MainPage(),
      home: AuthPage(),
    );
  }
}