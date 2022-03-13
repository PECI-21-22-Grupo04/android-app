// System Packages
import 'package:flutter/material.dart';

// Logic
import 'package:runx/authentication/firebase.dart';

// Screens
import 'package:runx/authentication/sign_in.dart';
import 'package:runx/user_profile/settings.dart';
import 'package:runx/profile/userdata.dart';

class SideNav extends StatefulWidget {
  const SideNav({Key? key}) : super(key: key);

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  @override
  Widget build(BuildContext context) {
    const user = UserData.myUser;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.fname + " " + user.lname),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  user.imagePath,
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
          ),

          // Settings Button
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Definições'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
          ),

          // Payments Button
          const Divider(),
          ListTile(
              title: const Text('Pagamentos'),
              leading: const Icon(Icons.payment_rounded),
              onTap: () {/* IR PARA PAGINA DE PAGAMENTOS */}),

          // Security Button
          const Divider(),
          ListTile(
              title: const Text('Segurança'),
              leading: const Icon(Icons.security_rounded),
              onTap: () {/* IR PARA PAGINA DE SEGURANÇA */}),

          // Logout Button
          const Divider(),
          ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.exit_to_app),
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () {
                FirebaseAuthenticationCaller().signOut().then((value) {
                  Navigator.pushAndRemoveUntil<void>(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => const Login()),
                      (Route<dynamic> route) => false);
                });
              }),
        ],
      ),
    );
  }
}
