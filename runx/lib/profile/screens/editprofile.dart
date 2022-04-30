// System Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// Logic
import 'package:runx/utils/upload_pic.dart';
import 'package:runx/caching/hive_helper.dart';
import 'package:runx/preferences/colors.dart';

// Screens
import 'package:runx/profile/widgets/textfieldwidget.dart';

// Widgets
import 'package:runx/profile/widgets/profilewidget.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    HiveHelper().openBox("UserProfile");
    Box userInfo = Hive.box("UserProfile");
    String? userEmail = FirebaseAuth.instance.currentUser!.email;

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
            const SizedBox(height: 20),
            const Text(
              "Imagem de Perfil",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ProfileWidget(
              imagePath:
                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
              isEdit: true,
              onClicked: () async {
                uploadPic();
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Imagem de Capa",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ProfileWidget(
              imagePath:
                  "https://www.challengetires.com/assets/img/placeholder.jpg",
              isEdit: true,
              onClicked: () async {
                uploadPic();
              },
            ),
            const SizedBox(height: 20),
            TextFieldWidget(
              label: 'Primeiro Nome',
              text: userInfo.get(userEmail).getFirstName(),
              onChanged: (fname) {},
            ),
            const SizedBox(height: 20),
            TextFieldWidget(
              label: 'Último Nome',
              text: userInfo.get(userEmail).getLastName(),
              onChanged: (lname) {},
            ),
            const SizedBox(height: 20),
            TextFieldWidget(
              label: 'Género',
              text: userInfo.get(userEmail).getSex(),
              onChanged: (location) {},
            ),
            const SizedBox(height: 20),
            TextFieldWidget(
              label: 'Data de Nascimento',
              text: userInfo.get(userEmail).getBirthdate(),
              onChanged: (email) {},
            ),
            const SizedBox(height: 20),
            TextFieldWidget(
              label: 'Endereço',
              text: userInfo.get(userEmail).getStreet(),
              onChanged: (about) {},
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFieldWidget(
                    label: 'Código Postal',
                    text: userInfo.get(userEmail).getPostCode(),
                    onChanged: (about) {},
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFieldWidget(
                    label: 'Cidade',
                    text: userInfo.get(userEmail).getCity(),
                    onChanged: (about) {},
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            TextFieldWidget(
              label: 'País',
              text: userInfo.get(userEmail).getCountry(),
              onChanged: (about) {},
            ),
            const SizedBox(height: 20),
            TextFieldWidget(
              label: 'Sobre',
              text: userInfo.get(userEmail).getPathologies(),
              maxLines: 10,
              onChanged: (about) {},
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(
                Icons.check_rounded,
                color: themeColorLight,
                size: 40,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
