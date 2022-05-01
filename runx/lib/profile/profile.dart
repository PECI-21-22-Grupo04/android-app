// System Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

// Logic
import 'package:runx/preferences/theme_model.dart';
import 'package:runx/preferences/colors.dart';

// Screens
import 'package:runx/profile/screens/editprofile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Box userInfo = Hive.box("UserProfile");
    String? userEmail = FirebaseAuth.instance.currentUser!.email;

    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        backgroundColor:
            themeNotifier.isDark ? themeSecondaryDark : themeSecondaryLight,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/background_icon.png',
                  height: 60.0,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.only(top: 16.0),
                          decoration: BoxDecoration(
                              color: themeNotifier.isDark
                                  ? themePrimaryDark
                                  : themePrimaryLight,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 96.0, top: 6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      userInfo.get(userEmail).getFirstName() +
                                          " " +
                                          userInfo.get(userEmail).getLastName(),
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      title: Text(userEmail!),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Profile Picture
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/images/profile_icon.png"),
                                  fit: BoxFit.cover)),
                          margin: const EdgeInsets.only(left: 16.0, top: 34.0),
                        ),
                        // Edit Button
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: IconButton(
                            icon: const Icon(Icons.edit_rounded),
                            tooltip: 'Alterar Perfil',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const EditProfile()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              margin: const EdgeInsets.only(top: 16.0),
                              decoration: BoxDecoration(
                                  color: themeNotifier.isDark
                                      ? themePrimaryDark
                                      : themePrimaryLight,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      "Membro desde " +
                                          userInfo
                                              .get(userEmail)
                                              .getRegisterDate(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  ListTile(
                                    title: const Text(
                                      "Género",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      userInfo.get(userEmail).getSex(),
                                    ),
                                    leading: const Icon(
                                        Icons.account_circle_rounded),
                                  ),
                                  ListTile(
                                    title: const Text(
                                      "Data de Nascimento",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      userInfo.get(userEmail).getBirthdate(),
                                    ),
                                    leading: const Icon(
                                        Icons.calendar_today_outlined),
                                  ),
                                  ListTile(
                                    title: const Text(
                                      "Endereço",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      userInfo.get(userEmail).getStreet(),
                                    ),
                                    leading: const Icon(Icons.house_rounded),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: ListTile(
                                        title: const Text(
                                          "Código Postal",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          userInfo.get(userEmail).getPostCode(),
                                        ),
                                        leading: const Icon(
                                            Icons.location_on_rounded),
                                      )),
                                      Expanded(
                                          child: ListTile(
                                        title: const Text(
                                          "Cidade",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          userInfo.get(userEmail).getCity(),
                                        ),
                                        leading: const Icon(
                                            Icons.location_city_rounded),
                                      ))
                                    ],
                                  ),
                                  ListTile(
                                    title: const Text(
                                      "País",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      userInfo.get(userEmail).getCountry(),
                                    ),
                                    leading: const Icon(Icons.flag_rounded),
                                  ),
                                  const SizedBox(height: 10.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
