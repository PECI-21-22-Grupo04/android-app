// System Packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
import 'package:runx/caching/models/instructor_profile.dart';

// Widgets
import 'package:runx/instructor/widgets/instructor_widgets.dart';

// Screens
import 'package:runx/instructor/screens/chat.dart';

class PersonalInstructor extends StatefulWidget {
  final String instEmail;

  const PersonalInstructor(this.instEmail, {Key? key}) : super(key: key);

  @override
  _PersonalInstructorState createState() => _PersonalInstructorState();
}

class _PersonalInstructorState extends State<PersonalInstructor> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ValueListenableBuilder<Box>(
          valueListenable: Hive.box("InstructorProfile").listenable(),
          builder: (context, box, _) {
            final availIns = box.values.toList().cast<InstructorProfile>();
            availIns.removeWhere(
                (element) => element.getEmail() != widget.instEmail);
            return buildProfile(context, availIns.first);
          },
        ),
      );

  Widget buildProfile(BuildContext context, InstructorProfile instructor) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 9.5),
                  buildProfileImage(),
                  buildFullName(instructor.getFullName()),
                  buildStatus(context, instructor.getRegisterDate()),
                  Container(
                    height: 70.0,
                    margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 219, 224, 227),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ElevatedButton(
                          child: Text(
                            'Conversar com ' + instructor.getFirstName(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(instructor),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  buildBio(context, instructor.getAboutMe()),
                  Container(
                    width: screenSize.width / 1.3,
                    height: 2.0,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
