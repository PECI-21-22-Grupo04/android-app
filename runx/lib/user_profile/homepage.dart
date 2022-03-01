// System Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Screens
import 'package:runx/authentication/firebase.dart';
import 'package:runx/authentication/sign_in.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
