// System Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

// Models
import 'package:runx/caching/models/plan.dart';

// Logic
import 'package:runx/preferences/colors.dart';
import 'package:runx/preferences/theme_model.dart';
import 'package:runx/payment/logic/paypal_webview.dart';

// Widgets
import 'package:runx/payment/widgets/button_profile.dart';

// Screens
import 'package:runx/library/screens/plan_details.dart';

Widget buildPremiumPlans(BuildContext context, accountState) {
  return Scaffold(body: buildPremiumList(context, accountState));
}

Widget buildPremiumList(BuildContext context, accountState) => Scaffold(
      body: ValueListenableBuilder<Box>(
        valueListenable: Hive.box("PremiumPlans").listenable(),
        builder: (context, box, _) {
          final plans = box.values.toList().cast<Plan>();
          plans.sort((a, b) => a.name.compareTo(b.name));
          return buildPremiumContent(context, plans, accountState);
        },
      ),
    );

Widget buildPremiumContent(context, List<Plan> plans, accountState) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  if (accountState == "free") {
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
              "Planos Premium apenas disponível para utilizadores com conta premium",
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
                    openAlertBox(context);
                  }),
            ),
          ],
        ),
      ),
    );
  } else if (plans.isEmpty) {
    return const Center(
      child: Center(
        child: Text(
            'Não conseguimos encontrar planos premium!\n\n\n Verifique a sua conexão à internet\nou\nPeça um plano ao seu instrutor',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24)),
      ),
    );
  } else {
    return Column(
      children: [
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: plans.length,
            itemBuilder: (BuildContext context, int index) {
              final plan = plans[index];
              return buildPremium(context, plan);
            },
          ),
        ),
      ],
    );
  }
}

Widget buildPremium(BuildContext context, Plan plan) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PlanDetails(context, plan: plan),
        ),
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 1,
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: 125,
              width: 110,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/program_icon.png'),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  plan.name,
                  style: const TextStyle(
                    color: themeColorLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.info_outline_rounded,
                      color: themeColorLight,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      (plan.forPathology == "")
                          ? "Indicado para: Público Geral"
                          : "Indicado para: " + plan.forPathology,
                      style: const TextStyle(
                        fontSize: 13,
                        letterSpacing: .3,
                      ),
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
}

openAlertBox(context) {
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
                                  email:
                                      FirebaseAuth.instance.currentUser!.email!,
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
