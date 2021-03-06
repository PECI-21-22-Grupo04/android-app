// System Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Logic
import 'package:runx/caching/hive_helper.dart';
import 'package:runx/preferences/theme_data.dart';
import 'package:runx/preferences/theme_model.dart';
import 'package:runx/chat/providers/auth_provider.dart';
import 'package:runx/chat/providers/chat_provider.dart';

// Screens
import 'package:runx/authentication/login.dart';
import 'package:runx/presentation/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  HiveHelper().registerAdapters();
  await HiveHelper().openBoxes();
  await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
        return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>(
                  create: (_) => AuthProvider(
                      firebaseFirestore: firebaseFirestore,
                      firebaseAuth: FirebaseAuth.instance)),
              Provider<ChatProvider>(
                  create: (_) => ChatProvider(
                      firebaseStorage: firebaseStorage,
                      firebaseFirestore: firebaseFirestore))
            ],
            child: MaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate
              ],
              supportedLocales: const [Locale('pt'), Locale('PT')],
              theme: themeNotifier.isDark
                  ? CustomThemeDark.darkTheme
                  : CustomThemeLight.lightTheme,
              debugShowCheckedModeBanner: false,
              home: const Initial(title: 'RunX'),
            ));
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
      return const BottomNav();
    }
  }
}
