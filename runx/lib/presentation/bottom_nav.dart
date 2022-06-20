// System Packages
import 'dart:convert';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:runx/caching/models/instructor_profile.dart';

// Logic
import 'package:runx/api.dart';
import 'package:runx/caching/hive_helper.dart';
import 'package:runx/caching/sharedpref_helper.dart';
import 'package:runx/preferences/colors.dart';
import 'package:runx/preferences/theme_model.dart';

// Screens
import 'package:runx/presentation/side_drawer.dart';
import 'package:runx/instructor/available_instructors.dart';
import 'package:runx/homepage/homepage.dart';
import 'package:runx/profile/profile.dart';
import 'package:runx/library/main_library.dart';
import 'package:runx/devices/devices.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  String _accountState = "";
  String _associatedInstructorEmail = "";

  @override
  void initState() {
    getAccountStatus().then(((status) {
      getAssociatedInstructorEmail().then((inst) => setState(() {
            _accountState = status!;
            _associatedInstructorEmail = inst!;
          }));
    }));
    super.initState();
  }

  int _selectedIndex = 0;
  String _pageTitle = "Início";

  static const List _pages = [
    HomePage(),
    Library(),
    InstructorList(),
    Devices(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    final cron = Cron();
    cron.schedule(Schedule.parse('*/30 * * * *'), () async {
      getPaidDate().then((value) {
        getPlan().then((value2) {
          checkAccountStatus(context, value, value2);
        });
      });
    });
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_pageTitle),
          centerTitle: true,
          toolbarHeight: 55,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_rounded),
              iconSize: 30.0,
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: <Widget>[
            (_accountState == "premium")
                ? Container(
                    width: 65.0,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/images/premium_account.png'),
                          fit: BoxFit.fill),
                    ),
                  )
                : Container(),
          ],
        ),
        drawer: const SideDrawer(),
        body: Stack(
          children: [
            Offstage(
              offstage: _selectedIndex != 0,
              child: _pages[0],
            ),
            Offstage(
              offstage: _selectedIndex != 1,
              child: _pages[1],
            ),
            Offstage(
              offstage: _selectedIndex != 2,
              child: _pages[2],
            ),
            Offstage(
              offstage: _selectedIndex != 3,
              child: _pages[3],
            ),
            Offstage(
              offstage: _selectedIndex != 4,
              child: _pages[4],
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor:
              themeNotifier.isDark ? themePrimaryDark : themePrimaryLight,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.watch,
                size: 19,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      );
    });
  }

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
        if (index == 0) {
          _pageTitle = "Início";
        } else if (index == 1) {
          _pageTitle = "Exercícios e Planos";
        } else if (index == 2) {
          if (_associatedInstructorEmail == "") {
            // 1º - Fetch data from DB
            APICaller().selectAvailableInstructors().then(
              (availInstructors) async {
                if (availInstructors != "ERROR" &&
                    json.decode(availInstructors)["code"] == 0 &&
                    json.decode(availInstructors)["data"] != null) {
                  // 2º - Convert json received to objects
                  List<InstructorProfile> itemsList =
                      List<InstructorProfile>.from(json
                          .decode(availInstructors)["data"][0]
                          .map((i) => InstructorProfile.fromJson(i)));
                  // 3º - Remove old cached items that no longer exist in database
                  for (InstructorProfile cachedIp
                      in await HiveHelper().getAll("InstructorProfile")) {
                    if (!itemsList
                        .map((item) => item.email)
                        .contains(cachedIp.email)) {
                      HiveHelper()
                          .removeFromBox("InstructorProfile", cachedIp.email);
                    }
                  }
                  // 4º Cache the new database items
                  for (InstructorProfile ip in List.from(itemsList)) {
                    HiveHelper().addToBox(ip, "InstructorProfile", ip.email);
                  }
                }
              },
            );
          }
          _pageTitle = "Instrutor";
        } else if (index == 3) {
          _pageTitle = "Dispositivos";
        } else {
          _pageTitle = "Perfil";
        }
      },
    );
  }
}

/* This function is inside a cronjob like function that runs every 30min and checks if the
users premium account is still valid */
Future<void>? checkAccountStatus(BuildContext context, paid, plan) {
  if (plan == "") {
  } else {
    var parsedDate = DateTime.parse(paid);
    var from = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
    DateTime to;
    if (plan == "Monthly" || plan == "monthly") {
      to = DateTime(parsedDate.year, parsedDate.month + 1, parsedDate.day);
    } else {
      to = DateTime(parsedDate.year + 1, parsedDate.month, parsedDate.day);
    }

    if ((to.difference(from).inHours / 24).round() <= 0) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Subscrição acabou!',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: const Text(
              'A sua conta deixou de ser premium.\nPara voltar a usufruir desta, volte a fazer um pagamento'),
          actions: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 21, 87, 192))),
                      onPressed: () {
                        SharedPreferencesHelper()
                            .saveStringToSF("accountStatus", "free");
                        SharedPreferencesHelper().saveStringToSF("plan", "");
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const BottomNav()),
                            (Route<dynamic> route) => false);
                      },
                      child: const Text(
                        'Entendido',
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
  }
  return null;
}

Future<String?> getPaidDate() async {
  return await SharedPreferencesHelper().getStringValuesSF("paidDate");
}

Future<String?> getPlan() async {
  return await SharedPreferencesHelper().getStringValuesSF("plan");
}

Future<String?> getAccountStatus() async {
  return await SharedPreferencesHelper().getStringValuesSF("accountStatus");
}

Future<String?> getAssociatedInstructorEmail() async {
  return await SharedPreferencesHelper()
      .getStringValuesSF("associatedInstructor");
}
