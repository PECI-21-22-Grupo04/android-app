// System Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_settings/app_settings.dart';
import 'package:settings_ui/settings_ui.dart';

// Logic
import 'package:runx/preferences/theme_model.dart';

// Screen
import 'package:runx/settings/screens/languagescreen.dart';

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
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
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
              SettingsTile(
                title: const Text('Definições da aplicação'),
                leading: const Icon(Icons.app_settings_alt_rounded),
                onPressed: (context) {
                  AppSettings.openAppSettings();
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Ecrã'),
            tiles: [
              SettingsTile(
                  title: const Text('Tema'),
                  trailing: Icon(themeNotifier.isDark
                      ? Icons.nightlight_round
                      : Icons.wb_sunny),
                  leading: const Icon(Icons.format_paint_rounded),
                  onPressed: (context) {
                    themeNotifier.isDark
                        ? themeNotifier.isDark = false
                        : themeNotifier.isDark = true;
                  }),
            ],
          ),
          SettingsSection(
            title: const Text('Notificações'),
            tiles: [
              SettingsTile(
                title: const Text('Notificações'),
                leading: const Icon(Icons.notifications_rounded),
                onPressed: (context) {
                  AppSettings.openNotificationSettings();
                },
              ),
            ],
          ),
        ],
      );
    });
  }
}
