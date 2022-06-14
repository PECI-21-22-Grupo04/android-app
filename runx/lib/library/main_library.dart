// System Packages
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:runx/caching/models/exercise.dart';
import 'package:runx/caching/models/plan.dart';

// Logic
import 'package:runx/preferences/colors.dart';
import 'package:runx/preferences/theme_model.dart';
import 'package:runx/api.dart';
import 'package:runx/caching/hive_helper.dart';

// Screens
import 'package:runx/library/screens/plans_library.dart';
import 'package:runx/library/screens/exercise_library.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeModel themeNotifier, child) {
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
                        APICaller().selectDefaultExercises().then(
                          (exer) async {
                            if (json.decode(exer)["code"] == 0 &&
                                json.decode(exer)["data"] != null) {
                              List<Exercise> itemsList = List<Exercise>.from(
                                json
                                    .decode(exer)["data"][0]
                                    .map((i) => Exercise.fromJson(i)),
                              );
                              // 3º - Remove old cached items
                              for (Exercise cachedIp in await HiveHelper()
                                  .getAll("FreeExercises")) {
                                if (!itemsList
                                    .map((item) => item.exerciseID)
                                    .contains(cachedIp.exerciseID)) {
                                  HiveHelper().removeFromBox(
                                      "FreeExercises", cachedIp.exerciseID);
                                }
                              }
                              // 4º Cache the new database items
                              for (Exercise ip in List.from(itemsList)) {
                                HiveHelper().addToBox(
                                    ip, "FreeExercises", ip.exerciseID);
                              }
                            }
                          },
                        );
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 75),
                    InkWell(
                      onTap: () {
                        APICaller().selectDefaultPrograms().then(
                          (prog) async {
                            if (json.decode(prog)["code"] == 0 &&
                                json.decode(prog)["data"] != null) {
                              List<Plan> itemsList = List<Plan>.from(
                                json
                                    .decode(prog)["data"][0]
                                    .map((i) => Plan.fromJson(i)),
                              );
                              // 3º - Remove old cached items
                              for (Plan cachedIp
                                  in await HiveHelper().getAll("FreePlans")) {
                                if (!itemsList
                                    .map((item) => item.planID)
                                    .contains(cachedIp.planID)) {
                                  HiveHelper().removeFromBox(
                                      "FreePlans", cachedIp.planID);
                                }
                              }
                              // 4º Cache the new database items
                              for (Plan ip in List.from(itemsList)) {
                                HiveHelper()
                                    .addToBox(ip, "FreePlans", ip.planID);
                              }
                            }
                          },
                        );
                        APICaller()
                            .selectClientPrograms(
                                email: FirebaseAuth.instance.currentUser!.email)
                            .then(
                          (premiumProg) async {
                            if (json.decode(premiumProg)["code"] == 0 &&
                                json.decode(premiumProg)["data"] != null) {
                              List<Plan> itemsList = List<Plan>.from(
                                json
                                    .decode(premiumProg)["data"][0]
                                    .map((i) => Plan.fromJson(i)),
                              );
                              // 3º - Remove old cached items
                              for (Plan cachedIp in await HiveHelper()
                                  .getAll("PremiumPlans")) {
                                if (!itemsList
                                    .map((item) => item.planID)
                                    .contains(cachedIp.planID)) {
                                  HiveHelper().removeFromBox(
                                      "PremiumPlans", cachedIp.planID);
                                }
                              }
                              // 4º Cache the new database items
                              for (Plan ip in List.from(itemsList)) {
                                HiveHelper()
                                    .addToBox(ip, "PremiumPlans", ip.planID);
                              }
                            }
                          },
                        );

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
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                "Biblioteca de Planos",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
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
          ),
        );
      },
    );
  }
}
