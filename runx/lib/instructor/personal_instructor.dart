// System Packages
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// Models
import 'package:runx/caching/models/instructor_profile.dart';

// Logic
import 'package:runx/api.dart';

// Widgets
import 'package:runx/instructor/widgets/instructor_widgets.dart';

// Screens
import 'package:runx/chat/chat_page.dart';

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
                  SizedBox(height: screenSize.height / 9.5),
                  ElevatedButton(
                    child: const Text(
                      "Avaliar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      alertDialog(context, instructor.getEmail(),
                          FirebaseAuth.instance.currentUser!.email!);
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Succesful instructor association
Future alertDialog(BuildContext context, String instEmail, String clientEmail) {
  num _rating = 1;
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "Avalie o seu instrutor!",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.lightGreen),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Center(
            child: RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _rating = rating.toInt();
              },
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: ElevatedButton(
              child: const Text(
                "Confirmar",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                APICaller()
                    .reviewAssociatedInstructor(
                        clientEmail: clientEmail,
                        instructorEmail: instEmail,
                        rating: _rating,
                        review: "")
                    .then((result) {
                  if (result != "ERROR" && json.decode(result)["code"] == 0 ||
                      json.decode(result)["code"] == 2) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "A sua review foi enviada, obrigado pelo feedback!",
                          style: TextStyle(fontSize: 16)),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "Ocorreu um erro, verifique a sua conexão ou tente mais tarde",
                          style: TextStyle(fontSize: 16)),
                    ));
                  }
                });
              },
            ),
          )
        ],
      );
    },
  );
}
