// System Packages
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('Perfil de Utilizador'),
      centerTitle: true,
      toolbarHeight: 70,
      leading: IconButton(
        iconSize: 45.0,
        icon: const Icon(Icons.menu_rounded),
        onPressed: () {
          //
          // ABRIR MENU
          //
        },
      ),
    ));
  }
}
