// System Packages
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

// Models
import 'package:runx/caching/models/history_instructor.dart';
import 'package:runx/caching/models/history_workout.dart';
import 'package:runx/caching/models/physical_data.dart';

// Logic
import 'package:runx/preferences/theme_model.dart';
import 'package:runx/caching/sharedpref_helper.dart';
import 'package:runx/caching/hive_helper.dart';
import 'package:runx/api.dart';

// Screens
import 'package:runx/history/instructor/instructor_history.dart';
import 'package:runx/history/workout/workout_history.dart';
import 'package:runx/history/physical/physical_history.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box userInfo = Hive.box("UserProfile");
  String _accountState = "";

  @override
  void initState() {
    getAccountStatus().then(
      (state) => setState(() {
        _accountState = state!;
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(body: buildGraphs(context, userInfo, _accountState));
    });
  }
}

Widget buildGraphs(BuildContext context, Box user, String state) {
  String? userEmail = FirebaseAuth.instance.currentUser!.email;

  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: SizedBox(
                  width: double.infinity,
                  height: 125,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient:
                          LinearGradient(begin: Alignment.bottomRight, colors: [
                        const Color.fromARGB(255, 14, 66, 223).withOpacity(.5),
                        const Color.fromARGB(255, 14, 66, 223).withOpacity(.5),
                      ]),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Bem vindo " +
                              user.get(userEmail).getFirstName().toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          (state == "free") ? "Conta Grátis" : "Conta Premium",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              InkWell(
                onTap: () {
                  APICaller()
                      .selectClientInstructorHistory(
                          email: FirebaseAuth.instance.currentUser!.email)
                      .then(
                    (history) async {
                      if (history != "ERROR" &&
                          json.decode(history)["code"] == 0 &&
                          json.decode(history)["data"] != null) {
                        List<HistoryInstructor> itemsList =
                            List<HistoryInstructor>.from(
                          json
                              .decode(history)["data"][0]
                              .map((i) => HistoryInstructor.fromJson(i)),
                        );

                        // 3º - Remove old cached items
                        await HiveHelper().clearBox("HistoryInstructor");

                        // 4º Cache the new database items
                        for (HistoryInstructor ip in List.from(itemsList)) {
                          HiveHelper().addToBox(ip, "HistoryInstructor");
                        }
                      }
                    },
                  );
                  sleep(const Duration(milliseconds: 200));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const InstructorHistory()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 125,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                          image: AssetImage(
                              "assets/images/instructor_background.jpg"),
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
                          "Histórico de Instrutores",
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
              const SizedBox(height: 25),
              InkWell(
                onTap: () {
                  APICaller()
                      .selectClientWorkoutHistory(
                          email: FirebaseAuth.instance.currentUser!.email)
                      .then(
                    (history) async {
                      if (history != "ERROR" &&
                          json.decode(history)["code"] == 0 &&
                          json.decode(history)["data"] != null) {
                        List<HistoryWorkout> itemsList =
                            List<HistoryWorkout>.from(
                          json
                              .decode(history)["data"][0]
                              .map((i) => HistoryWorkout.fromJson(i)),
                        );

                        // 3º - Remove old cached items
                        await HiveHelper().clearBox("WorkoutHistory");

                        // 4º Cache the new database items
                        for (HistoryWorkout ip in List.from(itemsList)) {
                          HiveHelper().addToBox(ip, "WorkoutHistory");
                        }
                      }
                    },
                  );
                  sleep(const Duration(milliseconds: 200));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const WorkoutHistory()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 125,
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
                          "Historico de Treino",
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
              const SizedBox(height: 25),
              InkWell(
                onTap: () {
                  // 1º - Fetch data from DB,
                  APICaller()
                      .selectClientInfo(email: userEmail)
                      .then((clientInfo) async {
                    if (clientInfo != "ERROR" &&
                        json.decode(clientInfo)["code"] == 0 &&
                        json.decode(clientInfo)["data"] != null) {
                      // 2º - Convert json received to objects
                      List<PhysicalData> itemsList = List<PhysicalData>.from(
                          json
                              .decode(clientInfo)["data"][0]
                              .map((i) => PhysicalData.fromJson(i)));

                      await HiveHelper().clearBox("PhysicalHistory");
                      // 3º - Save in Hive for caching
                      for (PhysicalData p in List.from(itemsList)) {
                        HiveHelper().addToBox(
                            p, "PhysicalHistory", p.dataID.toString());
                      }
                    }
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PhysicalHistory()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 125,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                          image: AssetImage("assets/images/health_icon.png"),
                          fit: BoxFit.fill)),
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
                          "Historico Físico",
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
}

Future<String?> getAccountStatus() async {
  return await SharedPreferencesHelper().getStringValuesSF("accountStatus");
}
