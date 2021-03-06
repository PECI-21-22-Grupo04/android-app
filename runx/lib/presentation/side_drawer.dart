// System Packages
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

// Models
import 'package:runx/caching/models/payment.dart';

// Logic
import 'package:runx/api.dart';
import 'package:runx/caching/models/physical_data.dart';
import 'package:runx/preferences/theme_model.dart';
import 'package:runx/preferences/colors.dart';
import 'package:runx/authentication/logic/firebase_services.dart';
import 'package:runx/caching/hive_helper.dart';

// Screens
import 'package:runx/authentication/login.dart';
import 'package:runx/settings/settings.dart';
import 'package:runx/payment/payment_history.dart';
import 'package:runx/faq/faq.dart';
import 'package:runx/history/physical/physical_history.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HiveHelper().openBox("UserProfile");
    Box userInfo = Hive.box("UserProfile");
    String? userEmail = FirebaseAuth.instance.currentUser!.email;

    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
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
                      accountName: Text(userInfo.get(userEmail).getFirstName() +
                          " " +
                          userInfo.get(userEmail).getLastName()),
                      accountEmail: Text(userInfo.get(userEmail).getEmail()),
                      currentAccountPicture: const CircleAvatar(
                        child: ClipOval(
                          child: ImageIcon(
                            AssetImage("assets/images/profile_icon.png"),
                            size: 50,
                          ),
                        ),
                      ),
                    ),

                    // Personal Info Button
                    ListTile(
                        leading:
                            const Icon(Icons.perm_device_information_rounded),
                        title: const Text('Dados F??sicos'),
                        onTap: () {
                          // 1?? - Fetch data from DB,
                          APICaller()
                              .selectClientInfo(email: userEmail)
                              .then((clientInfo) async {
                            if (clientInfo != "ERROR" &&
                                json.decode(clientInfo)["code"] == 0 &&
                                json.decode(clientInfo)["data"] != null) {
                              // 2?? - Convert json received to objects
                              List<PhysicalData> itemsList =
                                  List<PhysicalData>.from(json
                                      .decode(clientInfo)["data"][0]
                                      .map((i) => PhysicalData.fromJson(i)));
                              // 3?? - Save in Hive for caching
                              for (PhysicalData p in List.from(itemsList)) {
                                HiveHelper().addToBox(
                                    p, "PhysicalHistory", p.dataID.toString());
                              }
                            }
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PhysicalHistory()),
                          );
                        }),

                    // Payments Button
                    const Divider(),
                    ListTile(
                        title: const Text('Pagamentos'),
                        leading: const Icon(Icons.payment_rounded),
                        onTap: () {
                          // 1?? - Fetch data from DB,
                          APICaller()
                              .selectClientPaymentHistory(email: userEmail)
                              .then((paymentsMade) {
                            if (paymentsMade != "ERROR" &&
                                json.decode(paymentsMade)["code"] == 0 &&
                                json.decode(paymentsMade)["data"] != null) {
                              // 2?? - Convert json received to objects
                              List<Payment> itemsList = List<Payment>.from(json
                                  .decode(paymentsMade)["data"][0]
                                  .map((i) => Payment.fromJson(i)));
                              // 3?? - Save in Hive for caching
                              for (Payment p in List.from(itemsList)) {
                                HiveHelper().addToBox(p, "PaymentHistory",
                                    p.paymentID.toString());
                              }
                            }
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PaymentHistory()),
                          );
                        }),

                    // Security Button
                    const Divider(),
                    ListTile(
                        title: const Text('Seguran??a'),
                        leading: const Icon(Icons.security_rounded),
                        onTap: () {/* IR PARA PAGINA DE SEGURAN??A */}),

                    // Logout Button
                    const Divider(),
                    ListTile(
                        title: const Text('Encerrar Sess??o'),
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
                      title: const Text('Defini????es'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Settings(),
                          ),
                        );
                      },
                    ),
                    // Help and Feedback Button
                    ListTile(
                      leading: const Icon(Icons.help_rounded),
                      title: const Text('Ajuda e Feedback'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Faq()),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
