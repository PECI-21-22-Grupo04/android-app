// System Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Logic
import 'package:runx/preferences/colors.dart';
import 'package:runx/preferences/theme_model.dart';

// Screens
import 'package:runx/exercise/exercises_list.dart';

class Plans extends StatefulWidget {
  const Plans({Key? key}) : super(key: key);

  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  final List<Map> planList = [
    {
      "name": "Plano 1",
      "instructor": "Instrutor 1",
      "type": "Tipo 1",
    },
    {
      "name": "Plano 2",
      "instructor": "Instrutor 1",
      "type": "Tipo 1",
    },
    {
      "name": "Plano 3",
      "instructor": "Instrutor 3",
      "type": "Tipo 3",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Biblioteca de Planos'),
            toolbarHeight: 55,
            leading: Builder(builder: (context) => const BackButton()),
          ),
          backgroundColor: themeNotifier.isDark
              ? const Color.fromARGB(255, 24, 24, 24)
              : const Color.fromARGB(255, 240, 240, 240),
          body: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 15),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: planList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildList(context, index);
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildList(BuildContext context, int index) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const ExerciseList(),
            ));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color:
                  themeNotifier.isDark ? themePrimaryDark : themePrimaryLight,
            ),
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: const DecorationImage(
                        image: AssetImage("assets/images/program_icon.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        planList[index]['name'],
                        style: TextStyle(
                            color: !themeNotifier.isDark
                                ? themePrimaryDark
                                : themePrimaryLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.person_rounded,
                            color: themeColorLight,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(planList[index]['instructor'],
                              style: TextStyle(
                                  color: !themeNotifier.isDark
                                      ? themePrimaryDark
                                      : themePrimaryLight,
                                  fontSize: 13,
                                  letterSpacing: .3)),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.sports_gymnastics_rounded,
                            color: themeColorLight,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(planList[index]['type'],
                              style: TextStyle(
                                  color: !themeNotifier.isDark
                                      ? themePrimaryDark
                                      : themePrimaryLight,
                                  fontSize: 13,
                                  letterSpacing: .3)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ));
    });
  }
}
