// System Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Logic
import 'package:runx/authentication/firebase.dart';

// Screens
import 'package:runx/authentication/sign_in.dart';
import 'package:runx/presentation/side_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Inicio'),
          centerTitle: true,
          toolbarHeight: 40,
          leading: IconButton(
            iconSize: 25.0,
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SideNav()),
              );
            },
          ),
        ),
        body: Center(
          child: Text("UID --> " +
              ((FirebaseAuth.instance.currentUser?.uid).toString()) +
              "\nEMAIL --> " +
              (FirebaseAuth.instance.currentUser?.email).toString() +
              "\nVERIFIED? --> " +
              (FirebaseAuth.instance.currentUser?.emailVerified).toString()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseAuthenticationCaller()
                .signOut()
                .then((_) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (contex) => const Login()),
                    ));
          },
          child: const Icon(Icons.logout),
          tooltip: 'Logout',
        ),
      ),
    );
  }
}
