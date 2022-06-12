// System Packages
import 'package:hive/hive.dart';

// Generate Hive Model Adapter
part 'instructor_profile.g.dart';

@HiveType(typeId: 1)
class InstructorProfile extends HiveObject {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String birthdate;

  @HiveField(4)
  final String sex;

  @HiveField(5)
  final String country;

  @HiveField(6)
  final String registerDate;

  @HiveField(7)
  final String maxClients;

  @HiveField(8)
  final String currentClients;

  @HiveField(9)
  final String averageRating;

  @HiveField(10)
  final List<String> reviews;

  @HiveField(11)
  final String aboutMe;

  @HiveField(12)
  final String imagePath;

  @HiveField(13)
  final String firebaseID;

  InstructorProfile(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.birthdate,
      required this.sex,
      required this.country,
      required this.registerDate,
      required this.maxClients,
      required this.currentClients,
      required this.averageRating,
      required this.reviews,
      required this.aboutMe,
      required this.imagePath,
      required this.firebaseID});

  factory InstructorProfile.fromJson(Map<String, dynamic> parsedJson) {
    String currC;
    String avgR;
    if (parsedJson["currentClients"] != null) {
      currC = parsedJson["currentClients"].toString();
    } else {
      currC = "0";
    }
    if (parsedJson["averageRating"] != null) {
      avgR = parsedJson["averageRating"].toString() + "/5";
    } else {
      avgR = "Sem ratings!";
    }

    return InstructorProfile(
        email: parsedJson["mail"],
        firstName: parsedJson["firstName"],
        lastName: parsedJson["lastName"],
        birthdate: parsedJson["birthDate"].toString().split("T")[0],
        sex: parsedJson["sex"],
        country: parsedJson["country"],
        registerDate: parsedJson["registerDate"].toString().split("T")[0],
        maxClients: parsedJson["maxClients"].toString(),
        currentClients: currC,
        averageRating: avgR,
        reviews: [],
        aboutMe: parsedJson["aboutMe"],
        imagePath: parsedJson["imagePath"],
        firebaseID: parsedJson["firebaseID"]);
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

  String getBirthdate() {
    List<String> parsedDate = birthdate.split("-");
    return parsedDate[2] + "/" + parsedDate[1] + "/" + parsedDate[0];
  }

  String getSex() {
    return sex;
  }

  String getCountry() {
    return country;
  }

  String getRegisterDate() {
    List<String> parsedDate = registerDate.split("-");
    return parsedDate[2] + "/" + parsedDate[1] + "/" + parsedDate[0];
  }

  String getMaxClients() {
    return maxClients;
  }

  String getCurrentClients() {
    return currentClients;
  }

  String getAverageRating() {
    return averageRating;
  }

  List<String> getReviews() {
    return reviews;
  }

  int getAvailableSpotsLeft() {
    return (int.parse(maxClients) - int.parse(currentClients));
  }

  String getAboutMe() {
    return aboutMe;
  }

  String getImagePath() {
    return imagePath;
  }

  String getFullName() {
    return firstName + " " + lastName;
  }
}
