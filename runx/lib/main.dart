// System Packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// Screens
import 'package:runx/authentication/sign_in.dart';
import 'package:runx/preferences/theme_data.dart';
import 'package:runx/preferences/theme_model.dart';
import 'package:runx/presentation/page_nav.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
        return MaterialApp(
          theme: themeNotifier.isDark
              ? CustomThemeDark.darkTheme
              : CustomThemeLight.lightTheme,
          debugShowCheckedModeBanner: false,
          home: const Initial(title: 'RunX'),
        );
      }),
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
    // Check if user is signed in and show screen accordingly
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return const Login();
    } else {
      return const PageNav();
    }
  }
}
