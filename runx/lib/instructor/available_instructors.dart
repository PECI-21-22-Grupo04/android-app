// System Packages
import 'package:flutter/material.dart';

// Logic
import 'package:runx/caching/sharedpref_helper.dart';

// Screens
import 'package:runx/instructor/instructors_list.dart';
import 'package:runx/instructor/personal_instructor.dart';

class InstructorList extends StatefulWidget {
  const InstructorList({Key? key}) : super(key: key);

  @override
  State<InstructorList> createState() => _InstructorListState();
}

class _InstructorListState extends State<InstructorList> {
  var _associatedInstructorEmail = "";
  var _accountStatus = "";

  @override
  void initState() {
    getAssociatedInstructorEmail().then((value) {
      getAccountStatus().then((value2) => setState(() {
            _associatedInstructorEmail = value!;
            _accountStatus = value2!;
          }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_associatedInstructorEmail.toString() == "" ||
        _accountStatus.toString() == "free") {
      return const Scaffold(
        body: InstructorsList(),
      );
    } else {
      return Scaffold(
        body: PersonalInstructor(_associatedInstructorEmail.toString()),
      );
    }
  }
}

Future<String?> getAssociatedInstructorEmail() async {
  return await SharedPreferencesHelper()
      .getStringValuesSF("associatedInstructor");
}

Future<String?> getAccountStatus() async {
  return await SharedPreferencesHelper().getStringValuesSF("accountStatus");
}
