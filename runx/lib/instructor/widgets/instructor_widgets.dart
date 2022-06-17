// System Packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Logic
import 'package:runx/api.dart';
import 'package:runx/payment/logic/paypal_webview.dart';
import 'package:runx/preferences/theme_model.dart';
import 'package:runx/preferences/colors.dart';

// Screens
import 'package:runx/presentation/bottom_nav.dart';

Widget buildCoverImage(Size screenSize) {
  return Container(
    height: screenSize.height / 4,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/instructor_background.jpg'),
        fit: BoxFit.fill,
      ),
    ),
  );
}

Widget buildProfileImage() {
  return Center(
    child: Container(
      width: 140.0,
      height: 140.0,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/profile_icon.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(150.0),
        border: Border.all(
          color: Colors.white,
          width: 8,
        ),
      ),
    ),
  );
}

Widget buildFullName(String fullName) {
  return Text(
    fullName,
    style: const TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.w700,
    ),
  );
}

Widget buildStatus(BuildContext context, String registerDate) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
    ),
    child: Text(
      "Membro desde " + registerDate,
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w300,
      ),
    ),
  );
}

Widget buildStatContainer(
    String totalClients, String numClients, String rating) {
  return Container(
    height: 70.0,
    margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
    decoration: const BoxDecoration(
      color: Color.fromARGB(255, 219, 224, 227),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        buildStatItem(
          "Vagas",
          totalClients,
        ),
        buildStatItem("Clientes", numClients),
        buildStatItem("Rating", rating),
      ],
    ),
  );
}

Widget buildBio(BuildContext context, String aboutMe) {
  TextStyle bioTextStyle = const TextStyle(
    fontFamily: 'Spectral',
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    color: Color(0xFF799497),
    fontSize: 17.0,
  );
  return Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    padding: const EdgeInsets.all(10.0),
    child: Text(
      aboutMe,
      textAlign: TextAlign.center,
      style: bioTextStyle,
    ),
  );
}

Widget buildGetInTouch(BuildContext context, String fullName) {
  return Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    padding: const EdgeInsets.only(top: 20.0),
    child: Text(
      "Ter " + fullName + " como instrutor:",
      style: const TextStyle(fontSize: 18.0),
    ),
  );
}

Widget buildButtons(
    BuildContext context, String accountStatus, String instructorEmail) {
  return Padding(
    padding:
        const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 50, right: 50),
    child: Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            child: Container(
              height: 45.0,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: (accountStatus == "free")
                    ? const Text(
                        "Tornar-me Membro",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      )
                    : const Text(
                        "Associar",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
              ),
            ),
            onTap: () {
              (accountStatus == "free")
                  ? openAlertBox(context)
                  : confirmDialog(
                      context,
                      FirebaseAuth.instance.currentUser!.email!,
                      instructorEmail);
            },
          ),
        ),
      ],
    ),
  );
}

Widget buildStatItem(String label, String count) {
  TextStyle _statLabelTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.w300,
  );

  TextStyle _statCountTextStyle = const TextStyle(
    color: Colors.black54,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        count,
        style: _statCountTextStyle,
      ),
      Text(
        label,
        style: _statLabelTextStyle,
      ),
    ],
  );
}

// Display payment box
openAlertBox(BuildContext context) {
  bool pressAttention1 = false;
  bool pressAttention2 = false;
  String modality = "";
  String price = "";

  return showDialog(
    context: context,
    builder: (context) {
      pressAttention1 = false;
      pressAttention2 = false;
      return StatefulBuilder(
        builder: (context, setState) {
          return Consumer(
            builder: (context, ThemeModel themeNotifier, child) {
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
                              ),
                            ),
                          ),
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
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}

// Succesful instructor association
Future alertDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "Sucesso!",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.lightGreen),
          textAlign: TextAlign.center,
        ),
        content: const Text(
            "Está oficialmente associado a um instrutor! \nPoderá interagir com este na sua página de instrutores"),
        actions: <Widget>[
          InkWell(
            child: Container(
              height: 45.0,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: const Center(
                child: Text(
                  "Entendido",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const BottomNav(),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      );
    },
  );
}

Future<void> confirmDialog(
    BuildContext context, String clientEmail, String instructorEmail) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Associar este instrutor?',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
          'Ao realizar esta ação poderá ter contacto direto e pedir planos personalizados.\nTerá de esperar 7 dias se quiser trocar de instrutor'),
      actions: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar', style: TextStyle(fontSize: 20)),
                ),
              ),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () {
                    APICaller()
                        .associateInstructor(
                            FirebaseAuth.instance.currentUser!.email!,
                            instructorEmail)
                        .then(
                      (value) {
                        if (value != "ERROR" &&
                            jsonDecode(value)["code"] == 0) {
                          alertDialog(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Ocorreu um erro. \nVerifique a sua conexão ou tente mais tarde",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        }
                      },
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
