import 'package:flutter/material.dart';
import '../screens/create_post_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  Widget? page;

  //New
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // change to home
  void changeToHome() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex == 0) {
      page = const HomePage();
    } else if (_selectedIndex == 1) {
      page = CreatePostPage(setToHome: changeToHome);
    } else if (_selectedIndex == 2) {
      page = const ProfilePage();
    }
    return Scaffold(
      body: Center(
        // child: _pages.elementAt(_selectedIndex), //New
        child: page!,
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
