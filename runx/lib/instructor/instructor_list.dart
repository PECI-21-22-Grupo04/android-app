import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../preferences/colors.dart';
import '../preferences/theme_model.dart';

class InstructorList extends StatefulWidget {
  const InstructorList({Key? key}) : super(key: key);

  @override
  State<InstructorList> createState() => _InstructorListState();
}

class _InstructorListState extends State<InstructorList> {
  final List<Map> myInstructor = [
    {
      "name": "Francisco Marçal Teixeira",
      "city": "Porto",
      "image": "assets/images/profile_icon.png",
    },
  ];

  final List<Map> otherInstructors = [
    {
      "name": "Francisco Marçal Teixeira",
      "city": "Porto",
      "image": "assets/images/profile_icon.png",
    },
    {
      "name": "Francisco Marçal Teixeira",
      "city": "Porto",
      "image": "assets/images/profile_icon.png",
    },
    {
      "name": "Francisco Marçal Teixeira",
      "city": "Porto",
      "image": "assets/images/profile_icon.png",
    },
    {
      "name": "Francisco Marçal Teixeira",
      "city": "Porto",
      "image": "assets/images/profile_icon.png",
    },
    {
      "name": "Francisco Marçal Teixeira",
      "city": "Porto",
      "image": "assets/images/profile_icon.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        _firstListView(),
        _secondListView(),
      ],
    ));
  }

  Widget _firstListView() {
    return ListView.builder(
      itemCount: myInstructor.length + 1,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) => _buildMyInstView(context, index),
    );
  }

  Widget _secondListView() {
    return ListView.builder(
      itemCount: otherInstructors.length + 1,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) => _buildOtherInstView(context, index),
    );
  }

  Widget _buildMyInstView(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            Text(
              "O meu Instrutor",
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      );
    }
    return _buildInstructor(myInstructor, index - 1);
  }

  Widget _buildOtherInstView(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            Text(
              "Todos os Instrutores",
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      );
    }
    return _buildInstructor(otherInstructors, index - 1);
  }

  Widget _buildInstructor(List<Map> allinstructors, int index) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        margin: const EdgeInsets.only(bottom: 20.0),
        height: 200,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(otherInstructors[index]['image']),
                      fit: BoxFit.cover),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                      color:
                          themeNotifier.isDark ? themePrimaryDark : Colors.grey,
                    )
                  ]),
            )),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      otherInstructors[index]["name"],
                      style: const TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(otherInstructors[index]["city"],
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 18.0)),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                    color: themeNotifier.isDark
                        ? themeSecondaryDark
                        : themePrimaryLight,
                    boxShadow: [
                      BoxShadow(
                        color: themeNotifier.isDark
                            ? themePrimaryDark
                            : Colors.grey,
                        offset: const Offset(5.0, 5.0),
                      )
                    ]),
              ),
            )
          ],
        ),
      );
    });
  }
}
