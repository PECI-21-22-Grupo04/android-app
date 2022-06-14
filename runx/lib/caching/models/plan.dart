// System Packages
import 'package:hive/hive.dart';

// Generate Hive Model Adapter
part 'plan.g.dart';

@HiveType(typeId: 4)
class Plan extends HiveObject {
  @HiveField(0)
  final String planID;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String forPathology;

  @HiveField(4)
  final String thumbnailPath;

  @HiveField(5)
  final String videoPath;

  @HiveField(6)
  final String isPublic;

  @HiveField(7)
  final String isShowcase;

  @HiveField(8)
  final String creatorID;

  Plan({
    required this.planID,
    required this.name,
    required this.description,
    required this.forPathology,
    required this.thumbnailPath,
    required this.videoPath,
    required this.isPublic,
    required this.isShowcase,
    required this.creatorID,
  });

  factory Plan.fromJson(Map<String, dynamic> parsedJson) {
    return Plan(
        planID: parsedJson["programID"].toString(),
        name: parsedJson["pName"],
        description: parsedJson["pDescription"],
        forPathology: parsedJson["forPathology"],
        thumbnailPath: parsedJson["thumbnailPath"],
        videoPath: parsedJson["videoPath"],
        isPublic: parsedJson["isPublic"]["data"][0].toString(),
        isShowcase: parsedJson["isShowcaseProg"]["data"][0].toString(),
        creatorID: parsedJson["creatorIntsID"].toString());
  }
}
