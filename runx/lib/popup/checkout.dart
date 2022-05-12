import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:runx/paymentHistory/screens/checkout.dart';
import 'package:runx/preferences/colors.dart';
import 'package:runx/preferences/theme_model.dart';
import 'popup.dart';
import 'popup_content.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  bool pressAttention1 = false;
  bool pressAttention2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Open the popup window',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openAlertBox();
        },
        tooltip: 'Open Popup',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  showPopup(BuildContext context, Widget widget, {BuildContext? popupContext}) {
    Navigator.push(
        context,
        PopupLayout(
          child: PopupContent(
            content: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: SizedBox(
                    height: 300,
                    width: 400,
                    child: widget,
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  openAlertBox() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Consumer(
                builder: (context, ThemeModel themeNotifier, child) {
              return AlertDialog(
                  title: const Text(
                    "Escolha o seu plano",
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                        style: TextButton.styleFrom(primary: themeColorLight)),
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
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            print("tapped");
                                            setState(
                                                () => pressAttention1 = true);
                                            setState(
                                                () => pressAttention2 = false);
                                          },
                                          child: const ListTile(
                                            subtitle: Text(
                                              "Mensal",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            title: Text(
                                              "9,99€",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
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
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            print("tapped");
                                            setState(
                                                () => pressAttention1 = false);
                                            setState(
                                                () => pressAttention2 = true);
                                          },
                                          child: const ListTile(
                                            subtitle: Text(
                                              "Anual",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            title: Text(
                                              "99,99€",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ))),
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
                                    print("tapped");
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
                                )),
                          ])));
            });
          });
        });
  }
}
