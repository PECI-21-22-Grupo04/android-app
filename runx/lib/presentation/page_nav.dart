// System Packages
import 'package:flutter/material.dart';

// Logic
import 'package:runx/authentication/firebase.dart';
import 'package:runx/profile/userdata.dart';

// Screens
import 'package:runx/user_profile/homepage.dart';
import 'package:runx/user_profile/profile.dart';
import 'package:runx/exercise/exercises.dart';
import 'package:runx/device/devices.dart';
import 'package:runx/instructor/instructor.dart';
import 'package:runx/settings/settings.dart';
import 'package:runx/authentication/sign_in.dart';

class PageNav extends StatefulWidget {
  const PageNav({Key? key}) : super(key: key);

  @override
  State<PageNav> createState() => _PageNavState();
}

class _PageNavState extends State<PageNav> {
  int _selectedIndex = 0;
  String _pageTitle = "";

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
      if (index == 0) {
        _pageTitle = "Inicio";
      } else if (index == 1) {
        _pageTitle = "Exercicios e Planos";
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
    const user = UserData.myUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
        centerTitle: true,
        toolbarHeight: 65,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            iconSize: 35.0,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(user.fname + " " + user.lname),
                    accountEmail: Text(user.email),
                    currentAccountPicture: CircleAvatar(
                      child: ClipOval(
                        child: Image.network(
                          user.profilepic,
                          fit: BoxFit.cover,
                          width: 90,
                          height: 90,
                        ),
                      ),
                    ),
                  ),

                  // Personal Info Button
                  ListTile(
                      leading:
                          const Icon(Icons.perm_device_information_rounded),
                      title: const Text('Informação Pessoal'),
                      onTap: () {/* IR PARA PAGINA DE INFORMAÇÃO */}),

                  // Payments Button
                  const Divider(),
                  ListTile(
                      title: const Text('Pagamentos'),
                      leading: const Icon(Icons.payment_rounded),
                      onTap: () {/* IR PARA PAGINA DE PAGAMENTOS */}),

                  // Security Button
                  const Divider(),
                  ListTile(
                      title: const Text('Segurança'),
                      leading: const Icon(Icons.security_rounded),
                      onTap: () {/* IR PARA PAGINA DE SEGURANÇA */}),

                  // Logout Button
                  const Divider(),
                  ListTile(
                      title: const Text('Encerrar Sessão'),
                      leading: const Icon(Icons.exit_to_app),
                      iconColor: Colors.red,
                      textColor: Colors.red,
                      onTap: () {
                        FirebaseAuthenticationCaller().signOut().then((value) {
                          Navigator.pushAndRemoveUntil<void>(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const Login()),
                              (Route<dynamic> route) => false);
                        });
                      }),
                ],
              ),
            ),
            Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  children: <Widget>[
                    // Settings Button
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings_rounded),
                      title: const Text('Definições'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Settings()),
                        );
                      },
                    ),
                    // Help and Feedback Button
                    ListTile(
                        leading: const Icon(Icons.help_rounded),
                        title: const Text('Ajuda e Feedback'),
                        onTap: () {/* IR PARA PAGINA DE AJUDA */}),
                  ],
                ))
          ],
        ),
      ),
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
  }
}
