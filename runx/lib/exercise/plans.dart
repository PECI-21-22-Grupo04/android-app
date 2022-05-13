import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:runx/exercise/exercises_list.dart';
import 'package:runx/exercise/video_play.dart';
import 'package:runx/preferences/colors.dart';

import '../preferences/theme_model.dart';

class Plans extends StatefulWidget {
  const Plans({Key? key}) : super(key: key);

  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biblioteca de Planos"),
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
  final String? image;

  Item({this.name, this.instructor, this.type, this.image});
}

class Lists extends StatelessWidget {
  final List<Item> _data = [
    Item(
        name: 'Plano 1',
        instructor: "Instructor A",
        type: "Tipo A",
        image:
            "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        name: 'Plano 1',
        instructor: "Instructor A",
        type: "Tipo A",
        image:
            "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        name: 'Plano 1',
        instructor: "Instructor A",
        type: "Tipo A",
        image:
            "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        name: 'Plano 1',
        instructor: "Instructor A",
        type: "Tipo A",
        image:
            "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        name: 'Plano 1',
        instructor: "Instructor A",
        type: "Tipo A",
        image:
            "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        name: 'Plano 1',
        instructor: "Instructor A",
        type: "Tipo A",
        image:
            "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
    Item(
        name: 'Plano 1',
        instructor: "Instructor A",
        type: "Tipo A",
        image:
            "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
  ];

  Lists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const ExerciseList(),
                    ));
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
