// System Packages
import 'package:hive/hive.dart';

// Generate Hive Model Adapter
part 'free_exercise.g.dart';

@HiveType(typeId: 3)
class FreeExercise extends HiveObject {
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

  FreeExercise({
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
  });

  factory FreeExercise.fromJson(Map<String, dynamic> parsedJson) {
    return FreeExercise(
      exerciseID: parsedJson["exerciseID"].toString(),
      name: parsedJson["eName"],
      forPathology: parsedJson["forPathology"],
      difficulty: parsedJson["difficulty"],
      description: parsedJson["eDescription"],
      targetMuscle: parsedJson["targetMuscle"],
      thumbnailPath: parsedJson["thumbnailPath"],
      videoPath: parsedJson["videoPath"],
      isPublic: parsedJson["isPublic"]["data"][0].toString(),
      firebaseRef: parsedJson["firebaseRef"],
      creatorID: parsedJson["creatorID"].toString(),
    );
  }
}
