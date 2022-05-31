// System Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

// Logic
import 'package:runx/preferences/theme_model.dart';
import 'package:runx/preferences/colors.dart';
import 'package:runx/payment/logic/paypal_webview.dart';
import 'package:runx/caching/sharedpref_helper.dart';

// Screens
import 'package:runx/profile/screens/editprofile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Consumer<ThemeModel> build(BuildContext context) {
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
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 239, 232, 99)),
                  child: ListTile(
                    title: Text(
                      "Conta grátis! Pressione aqui para fazer upgrade",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      openAlertBox();
                    },
                  ),
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
            return Consumer(
                builder: (context, ThemeModel themeNotifier, child) {
              return AlertDialog(
                title: const Text(
                  "Escolha o seu plano",
                  textAlign: TextAlign.center,
                ),
                actions: <Widget>[
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
                                          )),
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
        });
  }
}
