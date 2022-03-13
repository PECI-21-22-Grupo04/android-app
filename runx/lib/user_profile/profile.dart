import 'package:flutter/material.dart';
import 'package:runx/presentation/side_nav.dart';
import 'package:runx/profile/profilewidget.dart';
import 'package:runx/profile/user.dart';
import 'package:runx/profile/userdata.dart';
import 'package:runx/profile/editprofile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    const user = UserData.myUser;

    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
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
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            ProfileWidget(
              imagePath: user.imagePath,
              onClicked: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const EditProfile()),
                );
              },
            ),
            const SizedBox(height: 24),
            buildName(user),
            const SizedBox(height: 48),
            buildAbout(user),
          ],
        ),
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.fname + " " + user.lname,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(User user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.about,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
