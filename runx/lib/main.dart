import 'package:flutter/material.dart';
import 'package:runx/pages/signin.dart';
import 'presentation/icons.dart';
import 'pages/homepage.dart';
import 'pages/settings.dart';
import 'pages/people.dart';
import 'pages/exercises.dart';
import 'pages/signin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RunX',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'RunX'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List _pages = [SignIn(), Exercises(), People(), Settings()];

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
        selectedIconTheme: IconThemeData(color: Colors.purple),
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.home_icon),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.exercise_icon),
            label: 'Exercícios',
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.people_icon),
            label: 'Pessoas',
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.settings_icon),
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
