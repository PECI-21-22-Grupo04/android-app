// System Packages
import 'package:hive/hive.dart';

// Generate Hive Model Adapter
part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
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
  final String street;

  @HiveField(6)
  final String postCode;

  @HiveField(7)
  final String city;

  @HiveField(8)
  final String country;

  @HiveField(9)
  final String registerDate;

  @HiveField(10)
  late String pathologies;

  UserProfile(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.birthdate,
      required this.sex,
      required this.street,
      required this.postCode,
      required this.city,
      required this.country,
      required this.registerDate,
      required this.pathologies});

  factory UserProfile.fromJson(Map<String, dynamic> parsedJson) {
    return UserProfile(
        email: parsedJson["mailC"],
        firstName: parsedJson["firstNameC"],
        lastName: parsedJson["lastNameC"],
        birthdate: parsedJson["birthdateC"].toString().split("T")[0],
        sex: parsedJson["sexC"],
        street: parsedJson["streetC"],
        postCode: parsedJson["postCodeC"],
        city: parsedJson["cityC"],
        country: parsedJson["countryC"],
        registerDate: parsedJson["registerDateC"],
        pathologies: parsedJson["pathologiesC"]);
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

  String getStreet() {
    return street;
  }

  String getPostCode() {
    return postCode;
  }

  String getCity() {
    return city;
  }

  String getCountry() {
    return country;
  }

  String getRegisterDate() {
    List<String> parsedDate = registerDate.split("-");
    return parsedDate[2] + "/" + parsedDate[1] + "/" + parsedDate[0];
  }

  String getPathologies() {
    return pathologies;
  }
}
