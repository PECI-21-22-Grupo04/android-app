import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  int themeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tema')),
      body: SettingsList(
        sections: [
          SettingsSection(tiles: [
            SettingsTile(
              title: const Text("Claro"),
              trailing: trailingWidget(0),
              onPressed: (BuildContext context) {
                changeTheme(0);
              },
            ),
            SettingsTile(
              title: const Text("Escuro"),
              trailing: trailingWidget(1),
              onPressed: (BuildContext context) {
                changeTheme(1);
              },
            ),
            SettingsTile(
              title: const Text("AMOLED"),
              trailing: trailingWidget(2),
              onPressed: (BuildContext context) {
                changeTheme(2);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget trailingWidget(int index) {
    return (themeIndex == index)
        ? const Icon(Icons.check, color: Colors.blue)
        : const Icon(null);
  }

  void changeTheme(int index) {
    setState(() {
      themeIndex = index;
    });
  }
}
