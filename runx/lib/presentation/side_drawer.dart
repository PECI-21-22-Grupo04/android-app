import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../authentication/firebase.dart';
import '../authentication/login.dart';
import '../preferences/colors.dart';
import '../preferences/theme_model.dart';
import '../profile/user.dart';
import '../profile/userdata.dart';
import '../settings/settings.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = UserData.myUser;
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.85, //20.0,
        child: Drawer(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: themeNotifier.isDark
                            ? themePrimaryDark
                            : themeColorLight,
                      ),
                      accountName: Text(user.fname + " " + user.lname),
                      accountEmail: Text(user.email),
                      currentAccountPicture: CircleAvatar(
                        child: ClipOval(
                          child: Image.network(
                            user.profilepic,
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                          ),
                        ),
                      ),
                    ),

                    // Personal Info Button
                    ListTile(
                        leading:
                            const Icon(Icons.perm_device_information_rounded),
                        title: const Text('Informação Pessoal'),
                        onTap: () {/* IR PARA PAGINA DE INFORMAÇÃO */}),

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
                        title: const Text('Encerrar Sessão'),
                        leading: const Icon(Icons.exit_to_app),
                        iconColor: Colors.red,
                        textColor: Colors.red,
                        onTap: () {
                          FirebaseAuthenticationCaller()
                              .signOut()
                              .then((value) {
                            Navigator.pushAndRemoveUntil<void>(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const Login()),
                                (Route<dynamic> route) => false);
                          });
                        }),
                  ],
                ),
              ),
              Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    children: <Widget>[
                      // Settings Button
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.settings_rounded),
                        title: const Text('Definições'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Settings()),
                          );
                        },
                      ),
                      // Help and Feedback Button
                      ListTile(
                          leading: const Icon(Icons.help_rounded),
                          title: const Text('Ajuda e Feedback'),
                          onTap: () {/* IR PARA PAGINA DE AJUDA */}),
                    ],
                  ))
            ],
          ),
        ),
      );
    });
  }
}
