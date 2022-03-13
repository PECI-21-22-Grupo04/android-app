// System Packages
import 'package:flutter/material.dart';
import 'package:runx/presentation/side_nav.dart';

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
        title: const Text('Exercicios'),
        centerTitle: true,
        toolbarHeight: 40,
        leading: IconButton(
          iconSize: 25.0,
          icon: const Icon(Icons.menu_rounded),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SideNav()),
            );
          },
        ),
      ),
    );
  }
}
