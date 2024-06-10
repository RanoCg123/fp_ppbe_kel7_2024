import 'package:flutter/material.dart';
import 'package:fp_forum_kel7_ppbe/screens/create_post_screen.dart';
import 'package:fp_forum_kel7_ppbe/screens/home_screen.dart';

class MainPage extends StatefulWidget {
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    CreatePostPage(),
    Center(
      child: Icon(
        Icons.people,
        size: 150,
      ),
    ),
  ];

  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  //New
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MainPage._pages.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'profile',
          ),
        ],
      ),
    );
  }
}
