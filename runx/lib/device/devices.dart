// System Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Logic
import 'package:runx/preferences/colors.dart';
import 'package:runx/preferences/theme_model.dart';

class Devices extends StatefulWidget {
  const Devices({Key? key}) : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
          body: buildGraphs(context),
          backgroundColor:
              themeNotifier.isDark ? themeSecondaryDark : themeSecondaryLight);
    });
  }
}

Widget buildGraphs(BuildContext context) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: <Widget>[
        const SizedBox(height: 50.0),
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 190,
                    color: Colors.blue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        ListTile(
                          title: Text(
                            "placeholder",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.directions_run_rounded,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Passos',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 120,
                    color: Colors.green,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        ListTile(
                          title: Text(
                            "placeholder",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.monitor_heart_rounded,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Batimento cardíaco',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 120,
                    color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        ListTile(
                          title: Text(
                            "placeholder",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.local_fire_department_rounded,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Calorias',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 190,
                    color: Colors.orange,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        ListTile(
                          title: Text(
                            "placeholder",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.timer_rounded,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Tempo total',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    ),
  );
}
