// System Packages
import 'package:hive/hive.dart';

// Generate Hive Model Adapter
part 'history_instructor.g.dart';

@HiveType(typeId: 6)
class HistoryInstructor extends HiveObject {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String signedDate;

  @HiveField(4)
  final String canceledDate;

  @HiveField(5)
  final String rating;

  HistoryInstructor(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.signedDate,
      required this.canceledDate,
      required this.rating});

  factory HistoryInstructor.fromJson(Map<String, dynamic> parsedJson) {
    return HistoryInstructor(
      email: parsedJson["mail"],
      firstName: parsedJson["firstName"],
      lastName: parsedJson["lastName"],
      signedDate: parsedJson["signedDate"].toString().split("T")[0],
      canceledDate: (parsedJson["canceledDate"] != null)
          ? (parsedJson["canceledDate"].toString().split("T")[0])
          : "",
      rating: parsedJson["rating"].toString(),
    );
  }

  String getEmail() {
    return email;
  }

  String getFirstName() {
    return firstName;
  }

  String getLastName() {
    return lastName;
  }

  String getSignedDate() {
    List<String> parsedDate = signedDate.split("-");
    return parsedDate[2] + "/" + parsedDate[1] + "/" + parsedDate[0];
  }

  String getCanceledDate() {
    if (canceledDate == "null") {
      return "Associado";
    }
    List<String> parsedDate = canceledDate.split("-");
    return parsedDate[2] + "/" + parsedDate[1] + "/" + parsedDate[0];
  }

  String getFullName() {
    return firstName + " " + lastName;
  }
}
