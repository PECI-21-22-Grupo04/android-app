// System Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Logic
import 'package:runx/preferences/colors.dart';
import 'package:runx/preferences/theme_model.dart';

// Screens
import 'package:runx/presentation/side_drawer.dart';
import 'package:runx/instructor/instructor_list.dart';
import 'package:runx/homepage/homepage.dart';
import 'package:runx/profile/profile.dart';
import 'package:runx/exercise/library.dart';
import 'package:runx/device/devices.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  String _pageTitle = "Início";

  static const List _pages = [
    HomePage(),
    Library(),
    InstructorList(),
    Devices(),
    Profile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _pageTitle = "Início";
      } else if (index == 1) {
        _pageTitle = "Exercícios e Planos";
      } else if (index == 2) {
        _pageTitle = "Instrutor";
      } else if (index == 3) {
        _pageTitle = "Dispositivos";
      } else {
        _pageTitle = "Perfil";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_pageTitle),
          centerTitle: true,
          toolbarHeight: 55,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_rounded),
              iconSize: 30.0,
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: const SideDrawer(),
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
          backgroundColor:
              themeNotifier.isDark ? themePrimaryDark : themePrimaryLight,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
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
              icon: Icon(
                Icons.watch,
                size: 19,
              ),
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
    });
  }
}
