// System Packages
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Save string in shared preferences
  saveStringToSF(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // Get string from shared preferences
  Future<String?> getStringValuesSF(String key) async {
    String stringValue = "";
    await SharedPreferences.getInstance().then((result) {
      stringValue = result.getString(key)!;
    });
    return stringValue;
  }

  // Remove string from shared preferences
  removeStringSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  // Check if string exists in shared preferences
  existsStringSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
