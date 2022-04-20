import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runx/exercise/exercises_list.dart';
import 'package:runx/exercise/video_page.dart';
import 'package:runx/preferences/colors.dart';
import 'package:runx/assets/assets.dart';

import '../preferences/theme_model.dart';

class ExerciseList extends StatefulWidget {
  const ExerciseList({Key? key}) : super(key: key);

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  final List<Map> ExercisesList = [
    {
      "name": "Exercício 1",
      "type": "Type A",
      "reps": "3x12",
      "image": placeholder1
    },
    {
      "name": "Exercício 2",
      "type": "Type A",
      "reps": "3x12",
      "image": placeholder1
    },
    {
      "name": "Exercício 3",
      "type": "Type B",
      "reps": "3x12",
      "image": placeholder1
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Plano A'),
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
                      itemCount: ExercisesList.length,
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
              builder: (_) => const VideoPage(),
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
                    image: DecorationImage(
                        image: NetworkImage(ExercisesList[index]['image']),
                        fit: BoxFit.fill),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        ExercisesList[index]['name'],
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
                          const SizedBox(
                            width: 5,
                          ),
                          Text(ExercisesList[index]['type'],
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
                          const SizedBox(
                            width: 5,
                          ),
                          Text(ExercisesList[index]['reps'],
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
