// System Packages
import 'package:hive/hive.dart';

// Logic
import 'package:runx/caching/models/user_profile.dart';
import 'package:runx/caching/models/instructor_profile.dart';
import 'package:runx/caching/models/payment.dart';

class HiveHelper {
  void registerAdapters() {
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(InstructorProfileAdapter());
    Hive.registerAdapter(PaymentAdapter());
  }

  Future<void> openBoxes() async {
    await Hive.openBox("UserProfile");
    await Hive.openBox("InstructorProfile");
    await Hive.openBox("PaymentHistory");
  }

  Future<dynamic> openBox<T>(String boxName) async {
    await Hive.openBox(boxName);
  }

  Future<void> addToBox<T>(item, String boxName, [String? itemKey]) async {
    if (itemKey != null) {
      final openBox = await Hive.openBox(boxName);
      openBox.put(itemKey, item);
    } else {
      final openBox = await Hive.openBox(boxName);
      openBox.add(item);
    }
  }
}
