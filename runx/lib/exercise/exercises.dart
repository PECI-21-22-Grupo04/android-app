import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:runx/exercise/video_play.dart';
import 'package:runx/preferences/colors.dart';

import '../preferences/theme_model.dart';

class Exercises extends StatefulWidget {
  const Exercises({Key? key}) : super(key: key);

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biblioteca de exercícios"),
        elevation: 2,
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.filter_list),
          )
        ],
      ),
      body: Lists(),
    );
  }
}

class Item {
  final String? name;
  final String? instructor;
  final String? type;
  final String? reps;
  final String? image;

  Item({this.name, this.instructor, this.type, this.reps, this.image});
}

class Lists extends StatelessWidget {
  final List<Item> _data = [
    Item(
        name: 'Exercício 1',
        instructor: "Instructor A",
        type: "Tipo A",
        reps: "3x12",
        image:
            "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        name: 'Exercício 1',
        instructor: "Instructor A",
        type: "Tipo A",
        reps: "3x12",
        image:
            "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        name: 'Exercício 1',
        instructor: "Instructor A",
        type: "Tipo A",
        reps: "3x12",
        image:
            "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        name: 'Exercício 1',
        instructor: "Instructor A",
        type: "Tipo A",
        reps: "3x12",
        image:
            "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        name: 'Exercício 1',
        instructor: "Instructor A",
        type: "Tipo A",
        reps: "3x12",
        image:
            "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        name: 'Exercício 1',
        instructor: "Instructor A",
        type: "Tipo A",
        reps: "3x12",
        image:
            "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        name: 'Exercício 1',
        instructor: "Instructor A",
        type: "Tipo A",
        reps: "3x12",
        image:
            "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
  ];

  Lists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    openAlertBox(String video) {
      return showDialog(
          context: context,
          builder: (context) {
            double height = MediaQuery.of(context).size.height / 2;
            return StatefulBuilder(builder: (context, setState) {
              return Consumer(
                  builder: (context, ThemeModel themeNotifier, child) {
                return Dialog(
                    insetPadding: EdgeInsets.zero,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.topRight,
                            child: VideoPlayAsset(video: video),
                            height: height,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.transparent),
                          ),
                        ),
                        Container(
                            width: 600,
                            height: 600,
                            color: themeNotifier.isDark
                                ? themeSecondaryDark
                                : themeSecondaryLight)
                      ],
                    ));
              });
            });
          });
    }

    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Container(
          color:
              themeNotifier.isDark ? themeSecondaryDark : themeSecondaryLight,
          child: ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: _data.length,
            itemBuilder: (BuildContext context, int index) {
              Item item = _data[index];
              return GestureDetector(
                  onTap: () {
                    openAlertBox('assets/videos/sample.mp4');
                  },
                  child: Card(
                    color: themeNotifier.isDark
                        ? const Color.fromARGB(255, 24, 24, 24)
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 1,
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              height: 125,
                              width: 110,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(item.image!),
                                      fit: BoxFit.cover)),
                            )),
                        Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    item.name!,
                                    style: const TextStyle(
                                        color: themeColorLight,
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
                                        width: 8,
                                      ),
                                      Text(item.instructor!,
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
                                        Icons.info_outline_rounded,
                                        color: themeColorLight,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(item.type!,
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
                                        width: 1,
                                      ),
                                      const Icon(
                                        FontAwesomeIcons.repeat,
                                        color: themeColorLight,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 9,
                                      ),
                                      Text(item.reps!,
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
                            ))
                      ],
                    ),
                  ));
            },
          ));
    });
  }
}
