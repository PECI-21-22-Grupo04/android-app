// System Packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:runx/caching/models/exercise.dart';

// Logic
import 'package:runx/preferences/colors.dart';
import 'package:runx/preferences/theme_model.dart';
import 'package:runx/api.dart';
import 'package:runx/caching/hive_helper.dart';

// Screens
import 'package:runx/library/plans_library.dart';
import 'package:runx/library/exercise_library.dart';

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
                    InkWell(
                      onTap: () {
                        APICaller().selectDefaultExercises().then((exer) async {
                          if (json.decode(exer)["code"] == 0 &&
                              json.decode(exer)["data"] != null) {
                            List<Exercise> itemsList = List<Exercise>.from(
                              json
                                  .decode(exer)["data"][0]
                                  .map((i) => Exercise.fromJson(i)),
                            );
                            // 3º - Remove old cached items
                            for (Exercise cachedIp
                                in await HiveHelper().getAll("FreeExercises")) {
                              if (!itemsList
                                  .map((item) => item.exerciseID)
                                  .contains(cachedIp.exerciseID)) {
                                HiveHelper().removeFromBox(
                                    "FreeExercises", cachedIp.exerciseID);
                              }
                            }
                            // 4º Cache the new database items
                            for (Exercise ip in List.from(itemsList)) {
                              HiveHelper()
                                  .addToBox(ip, "FreeExercises", ip.exerciseID);
                            }
                          }
                        });
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const ExerciseLibrary(),
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
                    const SizedBox(height: 75),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const PlanLibrary(),
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
