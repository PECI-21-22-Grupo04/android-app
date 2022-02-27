import 'package:flutter/material.dart';
import 'presentation/icons.dart';

import 'package:runx/user_profile/homepage.dart';
import 'package:runx/user_profile/exercises.dart';
import 'package:runx/user_profile/people.dart';
import 'package:runx/user_profile/settings.dart';

class PageNav extends StatefulWidget {
  const PageNav({Key? key}) : super(key: key);

  @override
  State<PageNav> createState() => _PageNavState();
}

class _PageNavState extends State<PageNav> {
  int _selectedIndex = 0;

  static const List _pages = [HomePage(), Exercises(), People(), Settings()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: const Text('RunX'),
      ), */
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
            icon: Icon(CustomIcons.homeicon),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.exerciseicon),
            label: 'Exercícios',
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.peopleicon),
            label: 'Pessoas',
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.settingsicon),
            label: 'Definições',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.chat),
          //   label: 'Chats',
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
