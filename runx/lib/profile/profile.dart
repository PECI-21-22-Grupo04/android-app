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

// Widgets
import 'package:runx/profile/widgets/premium_days.dart';

// Screens
import 'package:runx/profile/screens/editprofile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  String _accountState = "";
  String _paidDate = "";
  String _plan = "";
  String _sex = "";
  String _firstName = "";
  String _lastName = "";
  String _birthdate = "";
  String _address = "";
  String _postCode = "";
  String _city = "";
  String _country = "";
  String? userEmail = FirebaseAuth.instance.currentUser!.email;

  Box userInfo = Hive.box("UserProfile");

  @override
  void initState() {
    getAccountStatus().then((state) {
      getPaidDate().then((paidDate) {
        getPlan().then((plan) => setState(() {
              _accountState = state!;
              _paidDate = paidDate!;
              _plan = plan!;
              _sex = userInfo.get(userEmail).getSex();
              _birthdate = userInfo.get(userEmail).getBirthdate();
              _address = userInfo.get(userEmail).getStreet();
              _postCode = userInfo.get(userEmail).getPostCode();
              _city = userInfo.get(userEmail).getCity();
              _country = userInfo.get(userEmail).getCountry();
              _firstName = userInfo.get(userEmail).getFirstName();
              _lastName = userInfo.get(userEmail).getLastName();
            }));
      });
    });
    super.initState();
  }

  void reset() {
    setState(() {
      Box userInfo = Hive.box("UserProfile");
      _sex = userInfo.get(userEmail).getSex();
      _birthdate = userInfo.get(userEmail).getBirthdate();
      _address = userInfo.get(userEmail).getStreet();
      _postCode = userInfo.get(userEmail).getPostCode();
      _city = userInfo.get(userEmail).getCity();
      _country = userInfo.get(userEmail).getCountry();
      _firstName = userInfo.get(userEmail).getFirstName();
      _lastName = userInfo.get(userEmail).getLastName();
    });
  }

  @override
  Consumer<ThemeModel> build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        backgroundColor:
            themeNotifier.isDark ? themeSecondaryDark : themeSecondaryLight,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  decoration: (_accountState == "free")
                      ? const BoxDecoration(
                          color: Color.fromARGB(255, 239, 232, 99))
                      : const BoxDecoration(color: Colors.green),
                  child: ListTile(
                    title: (_accountState == "free")
                        ? const Text(
                            "Conta grátis! Pressione aqui para fazer upgrade",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : buildPremiumCountdown(_paidDate, _plan),
                    onTap: () {
                      (_accountState == "free") ? openAlertBox() : {};
                    },
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
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
                                      _firstName + " " + _lastName,
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
                                    trailing: IconButton(
                                      onPressed: () {
                                        reset();
                                      },
                                      icon: const Icon(Icons.refresh_rounded),
                                      color: const Color.fromARGB(
                                          255, 16, 198, 89),
                                      iconSize: 40,
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
                                      _sex,
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
                                      _birthdate,
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
                                      _address,
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
                                          _postCode,
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
                                          _city,
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
                                      _country,
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

  // Display payment box
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
        });
  }

  Future<String?> getAccountStatus() async {
    return await SharedPreferencesHelper().getStringValuesSF("accountStatus");
  }

  Future<String?> getPaidDate() async {
    return await SharedPreferencesHelper().getStringValuesSF("paidDate");
  }

  Future<String?> getPlan() async {
    return await SharedPreferencesHelper().getStringValuesSF("plan");
  }
}
