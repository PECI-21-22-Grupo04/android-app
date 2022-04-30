// System Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Logic
import 'package:runx/preferences/colors.dart';
import 'package:runx/preferences/theme_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Builder(
          builder: (context) => Scaffold(
                backgroundColor: themeNotifier.isDark
                    ? themeSecondaryDark
                    : themeSecondaryLight,
                body: Center(
                  child: Text("UID --> " +
                      ((FirebaseAuth.instance.currentUser?.uid).toString()) +
                      "\nEMAIL --> " +
                      (FirebaseAuth.instance.currentUser?.email).toString() +
                      "\nVERIFIED? --> " +
                      (FirebaseAuth.instance.currentUser?.emailVerified)
                          .toString()),
                ),
              ));
    });
  }
}
