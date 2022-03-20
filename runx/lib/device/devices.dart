// System Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runx/preferences/colors.dart';

import '../preferences/theme_model.dart';

class Devices extends StatefulWidget {
  const Devices({Key? key}) : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
          backgroundColor:
              themeNotifier.isDark ? secondaryDark : secondaryLight);
    });
  }
}
