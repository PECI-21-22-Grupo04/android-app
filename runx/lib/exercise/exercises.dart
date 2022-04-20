import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runx/exercise/video_page.dart';
import 'package:runx/exercise/video_play.dart';
import 'package:runx/preferences/colors.dart';
import 'package:runx/assets/assets.dart';
import 'package:runx/settings/settings.dart';

import '../preferences/theme_model.dart';

class Exercises extends StatefulWidget {
  const Exercises({Key? key}) : super(key: key);

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  final List<Map> ExercisesLists = [
    {
      "name": "Exercício 1",
      "instructor": "Instrutor 1",
      "type": "Tipo 1",
      "image": placeholder1
    },
    {
      "name": "Exercício 2",
      "instructor": "Instrutor 1",
      "type": "Tipo 1",
      "image": placeholder1
    },
    {
      "name": "Exercício 3",
      "instructor": "Instrutor 3",
      "type": "Tipo 3",
      "image": placeholder1
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Biblioteca de Exercícios'),
            toolbarHeight: 55,
            leading: Builder(builder: (context) => const BackButton()),
          ),
          backgroundColor:
              themeNotifier.isDark ? themeSecondaryDark : themeSecondaryLight,
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
        ),
      );
    });
  }

  Widget buildList(BuildContext context, int index) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VideoPage()),
            );
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
                            Text(ExercisesLists[index]['instructor'],
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
                            Text(ExercisesLists[index]['type'],
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
              )));
    });
  }
}
