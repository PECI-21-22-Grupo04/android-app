// System Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runx/preferences/colors.dart';

// Screens
import 'package:runx/profile/userdata.dart';
import 'package:runx/profile/editprofile.dart';
import 'package:runx/preferences/theme_model.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    const user = UserData.myUser;

    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        backgroundColor: themeNotifier.isDark ? secondaryDark : secondaryLight,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 250,
                width: double.infinity,
                child: PNetworkImage(
                  user.coverimg,
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
                                  ? primaryDark
                                  : primaryLight,
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
                                      user.fname + " " + user.lname,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      title: Text(user.location),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // profile pic
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                  image: NetworkImage(user.profilepic),
                                  fit: BoxFit.cover)),
                          margin: const EdgeInsets.only(left: 16.0, top: 34.0),
                        ),
                        //edit button
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
                                      ? primaryDark
                                      : primaryLight,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const ListTile(
                                    title: Text(
                                      "Informação",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  ListTile(
                                    title: const Text(
                                      "Email",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      user.email,
                                      style: TextStyle(
                                          color: themeNotifier.isDark
                                              ? const Color.fromARGB(
                                                  255, 214, 210, 210)
                                              : const Color.fromARGB(
                                                  255, 107, 107, 107)),
                                    ),
                                    leading: const Icon(Icons.email_rounded),
                                  ),
                                  ListTile(
                                    title: const Text(
                                      "Sobre",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      user.about,
                                      style: TextStyle(
                                          color: themeNotifier.isDark
                                              ? const Color.fromARGB(
                                                  255, 214, 210, 210)
                                              : const Color.fromARGB(
                                                  255, 107, 107, 107)),
                                    ),
                                    leading: const Icon(Icons.person_rounded),
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
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            ],
          ),
        ),
      );
    });
  }
}

class PNetworkImage extends StatelessWidget {
  final String? image;
  final BoxFit? fit;
  final double? width, height;
  const PNetworkImage(this.image, {Key? key, this.fit, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      image!,
      fit: fit,
      width: width,
      height: height,
    );
  }
}
