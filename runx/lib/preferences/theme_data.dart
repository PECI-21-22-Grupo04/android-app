import 'package:flutter/material.dart';
import 'package:runx/preferences/colors.dart';

class CustomThemeLight {
  static ThemeData get lightTheme {
    return ThemeData(
        brightness: Brightness.light,
        primarySwatch: buildMaterialColor(themeColorLight),
        textTheme: const TextTheme(
          headline6: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold), // page title
          bodyText1:
              TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold), // sidenav
          bodyText2: TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.bold), // text on scaffold
        ));
  }
}

class CustomThemeDark {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
        colorScheme:
            const ColorScheme.dark().copyWith(secondary: themeColorLight),
        textTheme: const TextTheme(
          headline6: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold), // page title
          bodyText1:
              TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold), // sidenav
          bodyText2: TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.bold), // text on scaffold
        ));
  }
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
