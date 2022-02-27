// System Packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Screens
import 'package:runx/auth_account/sign_in.dart';
import 'package:runx/page_nav.dart';
import 'package:runx/user_profile/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RunX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Initial(title: 'RunX'),
    );
  }
}

class Initial extends StatefulWidget {
  const Initial({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Initial> createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  @override
  Widget build(BuildContext context) {
    // Check if user is signed in
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return const Login();
    } else {
      return const PageNav();
    }
  }
}
