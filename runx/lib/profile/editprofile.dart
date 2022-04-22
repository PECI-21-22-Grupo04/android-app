// System Packages
import 'package:flutter/material.dart';
import 'package:runx/preferences/colors.dart';

// Logic
import 'package:runx/profile/user.dart';
import 'package:runx/profile/userdata.dart';

// Screens
import 'package:runx/profile/textfieldwidget.dart';
import 'package:runx/profile/profilewidget.dart';

import 'package:runx/utils/upload_pic.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserCon user = UserData.myUser;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Editar perfil'),
          toolbarHeight: 55,
          leading: Builder(builder: (context) => const BackButton()),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            const Text(
              "Imagem de Perfil",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ProfileWidget(
              imagePath: user.profilepic,
              isEdit: true,
              onClicked: () async {
                uploadPic();
              },
            ),
            const SizedBox(height: 24),
            const Text(
              "Imagem de Capa",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ProfileWidget(
              imagePath: user.coverimg,
              isEdit: true,
              onClicked: () async {
                uploadPic();
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Primeiro Nome',
              text: user.fname,
              onChanged: (fname) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Último Nome',
              text: user.lname,
              onChanged: (lname) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Cidade',
              text: user.location,
              onChanged: (location) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Email',
              text: user.email,
              onChanged: (email) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Sobre',
              text: user.about,
              maxLines: 5,
              onChanged: (about) {},
            ),
            IconButton(
              icon: const Icon(
                Icons.check_rounded,
                color: themeColorLight,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
