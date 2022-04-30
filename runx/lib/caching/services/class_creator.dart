// System Packages
import 'dart:convert';

// Logic
import 'package:runx/caching/models/user_profile.dart';

class ClassCreator {
  createUserProfile(String classType, String data) {
    if (classType == "UserProfile") {
      UserProfile newIns = UserProfile(
          email: json.decode(data)["mailC"],
          firstName: json.decode(data)["firstNameC"],
          lastName: json.decode(data)["lastNameC"],
          birthdate: json.decode(data)["birthdateC"].toString().split("T")[0],
          sex: json.decode(data)["sexC"],
          street: json.decode(data)["streetC"],
          postCode: json.decode(data)["postCodeC"],
          city: json.decode(data)["cityC"],
          country: json.decode(data)["countryC"],
          pathologies: json.decode(data)["pathologiesC"]);
      return newIns;
    }
  }
}
