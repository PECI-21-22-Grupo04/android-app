// System Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Logic
import 'package:runx/preferences/colors.dart';
import 'package:runx/preferences/theme_model.dart';

// Screens
import 'package:runx/exercise/exercises.dart';
import 'package:runx/exercise/plans.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
          backgroundColor:
              themeNotifier.isDark ? themeSecondaryDark : themeSecondaryLight,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const Exercises(),
                        ));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                                image: AssetImage(
                                    "assets/images/exercise_library_icon.png"),
                                fit: BoxFit.cover)),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.3),
                                  ])),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                "Biblioteca de Exercícios",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const Plans(),
                        ));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                                image: AssetImage(
                                    "assets/images/program_library_icon.png"),
                                fit: BoxFit.cover)),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.5),
                                    Colors.black.withOpacity(.3),
                                  ])),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                "Biblioteca de Planos",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
