// System Packages
import 'package:hive/hive.dart';

// Models
import 'package:runx/caching/models/user_profile.dart';
import 'package:runx/caching/models/instructor_profile.dart';
import 'package:runx/caching/models/payment.dart';
import 'package:runx/caching/models/free_exercise.dart';
import 'package:runx/caching/models/plan.dart';
import 'package:runx/caching/models/plan_exercise.dart';
import 'package:runx/caching/models/history_instructor.dart';
import 'package:runx/caching/models/history_workout.dart';
import 'package:runx/caching/models/physical_data.dart';

class HiveHelper {
  // Register hive adapters
  void registerAdapters() {
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(InstructorProfileAdapter());
    Hive.registerAdapter(PaymentAdapter());
    Hive.registerAdapter(FreeExerciseAdapter());
    Hive.registerAdapter(PlanAdapter());
    Hive.registerAdapter(PlanExerciseAdapter());
    Hive.registerAdapter(HistoryInstructorAdapter());
    Hive.registerAdapter(HistoryWorkoutAdapter());
    Hive.registerAdapter(PhysicalDataAdapter());
  }

  // Open boxes
  Future<void> openBoxes() async {
    await Hive.openBox("UserProfile");
    await Hive.openBox("InstructorProfile");
    await Hive.openBox("PaymentHistory");
    await Hive.openBox("FreeExercises");
    await Hive.openBox("FreePlans");
    await Hive.openBox("PremiumPlans");
    await Hive.openBox("PlanExercises");
    await Hive.openBox("HistoryInstructor");
    await Hive.openBox("WorkoutHistory");
    await Hive.openBox("PhysicalHistory");
  }

  // Add to box without key
  Future<dynamic> openBox<T>(String boxName) async {
    await Hive.openBox(boxName);
  }

  // Add to box with key
  Future<void> addToBox<T>(item, String boxName, [String? itemKey]) async {
    if (itemKey != null) {
      final openBox = await Hive.openBox(boxName);
      await openBox.put(itemKey, item);
    } else {
      final openBox = await Hive.openBox(boxName);
      await openBox.add(item);
    }
  }

  // Remove item from box with given key
  Future<void> removeFromBox<T>(String boxName, String itemKey) async {
    final openBox = await Hive.openBox(boxName);
    await openBox.delete(itemKey);
  }

  // Clear Box
  Future<void> clearBox(String boxName) async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }

  // Get all items in box
  Future<Iterable> getAll(String boxName) async {
    final box = await Hive.openBox(boxName);
    final userList = box.values;
    return userList;
  }
}
