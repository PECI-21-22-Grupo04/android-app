// System Packages
import 'package:flutter/material.dart';

// Screens
import 'package:runx/user_profile/homepage.dart';
import 'package:runx/exercise/exercises.dart';
import 'package:runx/device/devices.dart';
import 'package:runx/instructor/instructor.dart';
import 'package:runx/user_profile/profile.dart';

class PageNav extends StatefulWidget {
  const PageNav({Key? key}) : super(key: key);

  @override
  State<PageNav> createState() => _PageNavState();
}

class _PageNavState extends State<PageNav> {
  int _selectedIndex = 0;

  static const List _pages = [
    HomePage(),
    Exercises(),
    Instructor(),
    Devices(),
    Profile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: _pages[0],
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: _pages[1],
          ),
          Offstage(
            offstage: _selectedIndex != 2,
            child: _pages[2],
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: _pages[3],
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: _pages[4],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(color: Colors.purple),
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
