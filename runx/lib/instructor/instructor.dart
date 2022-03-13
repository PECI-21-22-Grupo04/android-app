// System Packages
import 'package:flutter/material.dart';

// Screens
import 'package:runx/presentation/side_nav.dart';

class Instructor extends StatefulWidget {
  const Instructor({Key? key}) : super(key: key);

  @override
  State<Instructor> createState() => _InstructorState();
}

class _InstructorState extends State<Instructor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('Instrutor'),
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
    ));
  }
}
