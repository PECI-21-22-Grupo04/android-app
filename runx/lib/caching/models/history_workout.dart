// System Packages
import 'package:hive/hive.dart';

// Generate Hive Model Adapter
part 'history_workout.g.dart';

@HiveType(typeId: 7)
class HistoryWorkout extends HiveObject {
  @HiveField(0)
  final String logID;

  @HiveField(1)
  final String pName;

  @HiveField(2)
  final String timeTaken;

  @HiveField(3)
  final String heartRate;

  @HiveField(4)
  final String caloriesBurnt;

  @HiveField(5)
  final String doneDate;

  HistoryWorkout(
      {required this.logID,
      required this.pName,
      required this.timeTaken,
      required this.heartRate,
      required this.caloriesBurnt,
      required this.doneDate});

  factory HistoryWorkout.fromJson(Map<String, dynamic> parsedJson) {
    return HistoryWorkout(
      logID: parsedJson["logID"].toString(),
      pName: parsedJson["pName"],
      timeTaken: parsedJson["timeTaken"],
      heartRate: parsedJson["heartRate"].toString(),
      caloriesBurnt: (parsedJson["caloriesBurnt"].toString()),
      doneDate: (parsedJson["doneDate"].toString().split("T")[0]),
    );
  }
}
