// System Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Logic
import 'package:runx/preferences/colors.dart';
import 'package:runx/preferences/theme_model.dart';
import 'package:runx/caching/sharedpref_helper.dart';
import 'package:runx/payment/logic/paypal_webview.dart';

// Widgets
import 'package:runx/payment/widgets/button_profile.dart';

class Devices extends StatefulWidget {
  const Devices({Key? key}) : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  String _accountState = "";
  bool isSwitchedFitbit = false;
  bool isSwitchedStrava = false;
  bool isSwitchedGoogle = false;

  @override
  void initState() {
    getAccountStatus().then((result) => setState(() {
          _accountState = result!;
        }));
    super.initState();
  }

  void toggleSwitchFitbit(bool value) {
    if (isSwitchedFitbit == false) {
      setState(() {
        isSwitchedFitbit = true;
      });
    } else {
      setState(() {
        isSwitchedFitbit = false;
      });
    }
  }

  void toggleSwitchStrava(bool value) {
    if (isSwitchedStrava == false) {
      setState(() {
        isSwitchedStrava = true;
      });
    } else {
      setState(() {
        isSwitchedStrava = false;
      });
    }
  }

  void toggleSwitchGoogle(bool value) {
    if (isSwitchedGoogle == false) {
      setState(() {
        isSwitchedGoogle = true;
      });
    } else {
      setState(() {
        isSwitchedGoogle = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
          body: buildGraphs(context, _accountState),
          backgroundColor:
              themeNotifier.isDark ? themeSecondaryDark : themeSecondaryLight);
    });
  }

  Widget buildGraphs(BuildContext context, [String? accountState]) {
    if (accountState == "free") {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  "assets/images/premium_feature.png",
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Text(
                "Funcionalidade Bloqueada",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.07,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              const Text(
                "Ligação de Dispositivos apenas disponível para utilizadores com conta premium",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: screenHeight * 0.06),
              Flexible(
                child: ProfileButton(
                    title: 'Tornar-me Membro',
                    onTap: () {
                      openAlertBox();
                    }),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Dispositivos Aceites",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.only(left: 30),
                child: ListTile(
                  leading: Image.asset("assets/images/fitbit.png"),
                  title: const Text(
                    "Conectar Fitbit",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  trailing: Switch(
                    onChanged: toggleSwitchFitbit,
                    value: isSwitchedFitbit,
                    activeColor: const Color.fromARGB(255, 224, 223, 223),
                    activeTrackColor: Colors.green,
                    inactiveThumbColor:
                        const Color.fromARGB(255, 224, 223, 223),
                    inactiveTrackColor: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.only(left: 30),
                child: ListTile(
                  leading: Image.asset("assets/images/strava.png"),
                  title: const Text(
                    "Conectar Strava",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  trailing: Switch(
                    onChanged: toggleSwitchStrava,
                    value: isSwitchedStrava,
                    activeColor: const Color.fromARGB(255, 224, 223, 223),
                    activeTrackColor: Colors.green,
                    inactiveThumbColor:
                        const Color.fromARGB(255, 224, 223, 223),
                    inactiveTrackColor: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.only(left: 30),
                child: ListTile(
                  leading: Image.asset("assets/images/googleFit.png"),
                  title: const Text(
                    "Conectar Google Fit",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  trailing: Switch(
                    onChanged: toggleSwitchGoogle,
                    value: isSwitchedGoogle,
                    activeColor: const Color.fromARGB(255, 224, 223, 223),
                    activeTrackColor: Colors.green,
                    inactiveThumbColor:
                        const Color.fromARGB(255, 224, 223, 223),
                    inactiveTrackColor: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  openAlertBox() {
    bool pressAttention1 = false;
    bool pressAttention2 = false;
    String modality = "";
    String price = "";
    return showDialog(
      context: context,
      builder: (context) {
        pressAttention1 = false;
        pressAttention2 = false;
        return StatefulBuilder(builder: (context, setState) {
          return Consumer(builder: (context, ThemeModel themeNotifier, child) {
            return AlertDialog(
              title: const Text(
                "Escolha o seu plano*",
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '* Comunicação direta com instrutores',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.end,
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '* Planos de treino personalizados',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.end,
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '* Ligação de dispositivos móveis',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.end,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.end,
                    ),
                    style: TextButton.styleFrom(primary: themeColorLight),
                  ),
                ),
              ],
              backgroundColor: themeNotifier.isDark
                  ? themeSecondaryDark
                  : themeSecondaryLight2,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: const EdgeInsets.only(top: 10.0),
              content: SizedBox(
                width: 1000.0,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                              child: Card(
                                  margin: const EdgeInsets.all(12.0),
                                  clipBehavior: Clip.antiAlias,
                                  color: themeNotifier.isDark
                                      ? (pressAttention1
                                          ? themeColorLight
                                          : themePrimaryDark)
                                      : (pressAttention1
                                          ? themeColorLight
                                          : themePrimaryLight),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      modality = "Monthly";
                                      price = "9.99";
                                      setState(() => pressAttention1 = true);
                                      setState(() => pressAttention2 = false);
                                    },
                                    child: ListTile(
                                      subtitle: Text(
                                        "Mensal",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: themeNotifier.isDark
                                                ? (pressAttention1
                                                    ? Colors.white
                                                    : Colors.white)
                                                : (pressAttention1
                                                    ? Colors.white
                                                    : Colors.black)),
                                      ),
                                      title: Text(
                                        "9,99€",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: themeNotifier.isDark
                                                ? (pressAttention1
                                                    ? Colors.white
                                                    : Colors.white)
                                                : (pressAttention1
                                                    ? Colors.white
                                                    : Colors.black)),
                                      ),
                                    ),
                                  ))),
                          Expanded(
                            child: Card(
                              margin: const EdgeInsets.all(12.0),
                              clipBehavior: Clip.antiAlias,
                              color: themeNotifier.isDark
                                  ? (pressAttention2
                                      ? themeColorLight
                                      : themePrimaryDark)
                                  : (pressAttention2
                                      ? themeColorLight
                                      : themePrimaryLight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  modality = "Yearly";
                                  price = "99.99";
                                  setState(() => pressAttention1 = false);
                                  setState(() => pressAttention2 = true);
                                },
                                child: ListTile(
                                  subtitle: Text(
                                    "Anual",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: themeNotifier.isDark
                                            ? (pressAttention2
                                                ? Colors.white
                                                : Colors.white)
                                            : (pressAttention2
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                  title: Text(
                                    "99,99€",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: themeNotifier.isDark
                                            ? (pressAttention2
                                                ? Colors.white
                                                : Colors.white)
                                            : (pressAttention2
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Card(
                        color: themeNotifier.isDark
                            ? themePrimaryDark
                            : themePrimaryLight,
                        margin: const EdgeInsets.all(12.0),
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (modality == "") {
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaypalPayment(
                                    pAmount: price,
                                    pModality: modality,
                                    email: FirebaseAuth
                                        .instance.currentUser!.email!,
                                  ),
                                ),
                              );
                            }
                          },
                          child: const ListTile(
                            leading: Icon(
                              FontAwesomeIcons.paypal,
                              color: Colors.indigo,
                            ),
                            title: Text(
                              "Paypal",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_rounded),
                          ),
                        ),
                      ),
                    ]),
              ),
            );
          });
        });
      },
    );
  }
}

Future<String?> getAccountStatus() async {
  return await SharedPreferencesHelper().getStringValuesSF("accountStatus");
}
