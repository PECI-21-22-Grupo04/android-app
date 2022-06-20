// System Packages
import 'package:hive/hive.dart';

// Generate Hive Model Adapter
part 'physical_data.g.dart';

@HiveType(typeId: 8)
class PhysicalData extends HiveObject {
  @HiveField(0)
  final int dataID;

  @HiveField(1)
  final int height;

  @HiveField(2)
  final int weight;

  @HiveField(3)
  final int bmi;

  @HiveField(4)
  final String fitness;

  @HiveField(5)
  final String measuredDate;

  PhysicalData({
    required this.dataID,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.fitness,
    required this.measuredDate,
  });

  factory PhysicalData.fromJson(Map<String, dynamic> parsedJson) {
    return PhysicalData(
      dataID: parsedJson["physicalDataID"],
      height: parsedJson["height"],
      weight: parsedJson["weight"],
      bmi: parsedJson["BMI"],
      fitness: parsedJson["fitness"],
      measuredDate: parsedJson["measuredDate"],
    );
  }
}
