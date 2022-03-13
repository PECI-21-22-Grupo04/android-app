// System Packages
import 'package:flutter/material.dart';

// Screens
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
        toolbarHeight: 65,
        leading: IconButton(
          iconSize: 35.0,
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
