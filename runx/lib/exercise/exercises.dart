import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runx/preferences/colors.dart';

import '../preferences/theme_model.dart';

class Exercises extends StatefulWidget {
  const Exercises({Key? key}) : super(key: key);

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  final List<Map> ExercisesLists = [
    {
      "name": "Biblioteca de exercícios grátis",
      "instructor": "RunX",
      "type": "Tipo 1",
      "image":
          "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png"
    },
    {
      "name": "Biblioteca de planos grátis",
      "instructor": "RunX",
      "type": "Tipo 2",
      "image":
          "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png"
    },
    {
      "name": "Exercícios",
      "instructor": "Instrutor 1",
      "type": "Tipo 2",
      "image":
          "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png"
    },
    {
      "name": "Planos",
      "instructor": "Instrutor 2",
      "type": "Tipo 2",
      "image":
          "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png"
    },
    {
      "name": "Exercícios",
      "instructor": "Instrutor 3",
      "type": "Tipo 4",
      "image":
          "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png"
    },
    {
      "name": "Planos",
      "instructor": "Instrutor 4",
      "type": "Tipo 5",
      "image":
          "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
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
                    itemCount: ExercisesLists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildList(context, index);
                    }),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildList(BuildContext context, int index) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: themeNotifier.isDark ? primaryDark : primaryLight,
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
                image: DecorationImage(
                    image: NetworkImage(ExercisesLists[index]['image']),
                    fit: BoxFit.fill),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    ExercisesLists[index]['name'],
                    style: TextStyle(
                        color:
                            !themeNotifier.isDark ? primaryDark : primaryLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.person_rounded,
                        color: themeNotifier.isDark
                            ? const Color.fromRGBO(100, 255, 218, 1)
                            : const Color.fromARGB(255, 101, 50, 218),
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(ExercisesLists[index]['instructor'],
                          style: TextStyle(
                              color: !themeNotifier.isDark
                                  ? primaryDark
                                  : primaryLight,
                              fontSize: 13,
                              letterSpacing: .3)),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.sports_gymnastics_rounded,
                        color: themeNotifier.isDark
                            ? const Color.fromRGBO(100, 255, 218, 1)
                            : const Color.fromARGB(255, 101, 50, 218),
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(ExercisesLists[index]['type'],
                          style: TextStyle(
                              color: !themeNotifier.isDark
                                  ? primaryDark
                                  : primaryLight,
                              fontSize: 13,
                              letterSpacing: .3)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
