// System Packages
import 'package:flutter/material.dart';

// Logic
import 'package:runx/profile/user.dart';
import 'package:runx/profile/userdata.dart';

// Screens
import 'package:runx/profile/textfieldwidget.dart';
import 'package:runx/profile/profilewidget.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User user = UserData.myUser;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          physics: const BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath: user.imagePath,
              isEdit: true,
              onClicked: () async {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'First Name',
              text: user.fname,
              onChanged: (fname) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Last Name',
              text: user.lname,
              onChanged: (lname) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Email',
              text: user.email,
              onChanged: (email) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'About',
              text: user.about,
              maxLines: 5,
              onChanged: (about) {},
            ),
          ],
        ),
      ),
    );
  }
}
