// System Packages
import 'package:hive/hive.dart';

// Logic
import 'package:runx/caching/models/user_profile.dart';

class HiveHelper {
  void registerAdapters() {
    Hive.registerAdapter(UserProfileAdapter());
  }

  openBoxes() async {
    await Hive.openBox("UserProfile");
  }

  openBox<T>(String boxName) async {
    await Hive.openBox(boxName);
  }

  void addToBox<T>(item, String boxName, [String? itemKey]) async {
    if (itemKey != null) {
      final openBox = await Hive.openBox(boxName);
      openBox.put(itemKey, item);
    } else {
      final openBox = await Hive.openBox(boxName);
      openBox.add(item);
    }
  }
}
