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
  late String maxClients;

  @HiveField(8)
  late String currentClients;

  @HiveField(9)
  late String averageRating;

  @HiveField(10)
  late List<String> reviews;

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
      required this.reviews});

  factory InstructorProfile.fromJson(Map<String, dynamic> parsedJson) {
    return InstructorProfile(
        email: parsedJson["mailI"],
        firstName: parsedJson["firstNameI"],
        lastName: parsedJson["lastNameI"],
        birthdate: parsedJson["birthdateI"].toString().split("T")[0],
        sex: parsedJson["sexI"],
        country: parsedJson["countryI"],
        registerDate: parsedJson["registerDateI"].toString().split("T")[0],
        maxClients: parsedJson["maxClientsI"],
        currentClients: parsedJson["currentClientsI"],
        averageRating: parsedJson["averageRatingI"],
        reviews: []);
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
    return maxClients;
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
}
