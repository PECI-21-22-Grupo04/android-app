// System Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runx/preferences/colors.dart';

import '../preferences/theme_model.dart';

class Instructor extends StatefulWidget {
  const Instructor({Key? key}) : super(key: key);

  @override
  State<Instructor> createState() => _InstructorState();
}

class _InstructorState extends State<Instructor> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
          backgroundColor:
              themeNotifier.isDark ? themeSecondaryDark : themeSecondaryLight);
    });
  }
}
