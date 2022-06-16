// System Packages
import 'package:hive/hive.dart';

// Generate Hive Model Adapter
part 'plan_exercise.g.dart';

@HiveType(typeId: 5)
class PlanExercise extends HiveObject {
  @HiveField(0)
  final String exerciseID;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String forPathology;

  @HiveField(3)
  final String difficulty;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String targetMuscle;

  @HiveField(6)
  final String thumbnailPath;

  @HiveField(7)
  final String videoPath;

  @HiveField(8)
  final String isPublic;

  @HiveField(9)
  final String firebaseRef;

  @HiveField(10)
  final String creatorID;

  @HiveField(11)
  final String includedDate;

  @HiveField(12)
  final String numSets;

  @HiveField(13)
  final String numReps;

  @HiveField(14)
  final String durationTime;

  @HiveField(15)
  final String exerciseOrder;

  @HiveField(16)
  final String belongsToProgramID;

  PlanExercise({
    required this.exerciseID,
    required this.name,
    required this.forPathology,
    required this.difficulty,
    required this.description,
    required this.targetMuscle,
    required this.thumbnailPath,
    required this.videoPath,
    required this.isPublic,
    required this.firebaseRef,
    required this.creatorID,
    required this.includedDate,
    required this.numSets,
    required this.numReps,
    required this.durationTime,
    required this.exerciseOrder,
    required this.belongsToProgramID,
  });

  factory PlanExercise.fromJson(Map<String, dynamic> parsedJson) {
    return PlanExercise(
      exerciseID: parsedJson["exerciseID"].toString(),
      name: parsedJson["eName"],
      forPathology: parsedJson["forPathology"],
      difficulty: parsedJson["difficulty"],
      description: parsedJson["eDescription"],
      targetMuscle: parsedJson["targetMuscle"],
      thumbnailPath: parsedJson["thumbnailPath"],
      videoPath: parsedJson["videoPath"],
      isPublic: "0",
      firebaseRef: parsedJson["firebaseRef"],
      creatorID: parsedJson["creatorID"].toString(),
      includedDate: parsedJson["includedDate"].toString(),
      numSets: parsedJson["numSets"].toString(),
      numReps: parsedJson["numReps"].toString(),
      durationTime: parsedJson["durationTime"].toString(),
      exerciseOrder: parsedJson["exerciseOrder"].toString(),
      belongsToProgramID: parsedJson["programID"].toString(),
    );
  }
}
