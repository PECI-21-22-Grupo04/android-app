// System Packages
import 'package:flutter/material.dart';

// Screens
import 'package:runx/instructor/screens/instructors_list.dart';

class InstructorList extends StatefulWidget {
  const InstructorList({Key? key}) : super(key: key);

  @override
  State<InstructorList> createState() => _InstructorListState();
}

class _InstructorListState extends State<InstructorList> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: InstructorsList(),
    );
  }
}
