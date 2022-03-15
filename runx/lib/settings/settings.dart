import 'package:flutter/material.dart';
import 'package:runx/settings/languagescreen.dart';
import 'package:runx/settings/themescreen.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Definições')),
      body: buildSettingsList(),
    );
  }

  Widget buildSettingsList() {
    return SettingsList(
      sections: [
        SettingsSection(
          title: const Text('Comum'),
          tiles: [
            SettingsTile(
              title: const Text('Linguagem'),
              leading: const Icon(Icons.language_rounded),
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const LanguagesScreen(),
                ));
              },
            ),
          ],
        ),
        SettingsSection(
          title: const Text('Ecrã'),
          tiles: [
            SettingsTile(
              title: const Text('Tema'),
              leading: const Icon(Icons.format_paint_rounded),
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const ThemeScreen(),
                ));
              },
            ),
          ],
        ),
      ],
    );
  }
}
