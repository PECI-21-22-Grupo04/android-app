// System Packages
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

// Logic
import 'package:runx/caching/sharedpref_helper.dart';

class APICaller {
  //final String host = 'http://localhost:';
  //final String port = '8080';
  final String deployedAPI = 'https://runx2022.herokuapp.com';

  ///***************** AUTHENTICATION ******************///
  /// API calls needed for authentication operations    ///
  ///***************************************************///
  Future<String> selectClient({String? email}) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/selectClient'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "email": email.toString(),
            }),
          )
          .timeout(const Duration(seconds: 4));

      if (jsonDecode((response.body))["code"] == 0) {
        try {
          final response2 = await http
              .post(
                Uri.parse(deployedAPI + '/selectLatestClientPayment'),
                headers: <String, String>{
                  'Content-Type':
                      'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: (<String, String>{
                  "email": email.toString(),
                }),
              )
              .timeout(const Duration(seconds: 2));

          if (jsonDecode((response2.body))["code"] == 0 ||
              jsonDecode((response2.body))["code"] == 2) {
            // Check status of user account
            SharedPreferencesHelper().saveStringToSF(
                "paidDate",
                jsonDecode((response2.body))["paidDate"]
                    .toString()
                    .split(" ")[0]);
            if (daysBetween(
                    jsonDecode((response2.body))["paidDate"]
                        .toString()
                        .split(" ")[0],
                    jsonDecode((response2.body))["plan"]) >
                0) {
              SharedPreferencesHelper().saveStringToSF("accountStatus",
                  jsonDecode((response2.body))["accountStatus"]);
              SharedPreferencesHelper()
                  .saveStringToSF("plan", jsonDecode((response2.body))["plan"]);
            } else {
              SharedPreferencesHelper().saveStringToSF("accountStatus", "free");
              SharedPreferencesHelper().saveStringToSF("plan", "");
            }
          }
        } on Exception {
          return "ERROR";
        }
      }
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> createClient(
      {String? email,
      String? fname,
      String? lname,
      String? birthdate,
      String? sex,
      String? street,
      String? postCode,
      String? city,
      String? country}) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/createClient'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "email": email.toString(),
              "fname": fname.toString(),
              "lname": lname.toString(),
              "birthdate": birthdate.toString(),
              "sex": sex.toString(),
              "street": street.toString(),
              "postCode": postCode.toString(),
              "city": city.toString(),
              "country": country.toString(),
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> deleteClient({String? email}) async {
    const r = RetryOptions(maxAttempts: 3);
    try {
      final response = await r.retry(
        () => http
            .post(Uri.parse(deployedAPI + '/deleteClient'),
                headers: <String, String>{
                  'Content-Type':
                      'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: (<String, String>{
                  "email": email.toString(),
                }))
            .timeout(const Duration(milliseconds: 800)),
        retryIf: (e) => e is TimeoutException,
      );
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> updateFirebaseID({String? email, String? firebaseID}) async {
    const r = RetryOptions(maxAttempts: 3);
    try {
      final response = await r.retry(
        () => http
            .post(
              Uri.parse(deployedAPI + '/updateFirebaseID'),
              headers: <String, String>{
                'Content-Type':
                    'application/x-www-form-urlencoded; charset=UTF-8'
              },
              body: (<String, String>{
                "email": email.toString(),
                "firebaseID": firebaseID.toString(),
              }),
            )
            .timeout(const Duration(milliseconds: 800)),
        retryIf: (e) => e is TimeoutException,
      );
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  ///**************** CLIENT ACTIONS *************///
  /// API calls needed for client actions         ///
  ///*********************************************///
  Future<String> addClientInfo(
      {String? email,
      String? height,
      String? weight,
      String? fitness,
      String? bmi,
      String? pathologies}) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/addClientInfo'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "email": email.toString(),
              "height": height.toString(),
              "weight": weight.toString(),
              "fitness": fitness.toString(),
              "bmi": bmi.toString(),
              "pathologies": pathologies.toString(),
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> finishWorkout(
      {String? email, String? progID, String? timeTaken}) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/finishWorkout'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "email": email.toString(),
              "progID": progID.toString(),
              "timeTaken": timeTaken.toString(),
              "caloriesBurnt": 0.toString(),
              "heartRate": 0.toString(),
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> selectClientWorkoutHistory({String? email}) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/selectClientWorkoutHistory'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "email": email.toString(),
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> selectClientInfo({String? email}) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/selectClientInfo'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "email": email.toString(),
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> updateClient(
      {String? email,
      String? fname,
      String? lname,
      String? birthdate,
      String? sex,
      String? street,
      String? postCode,
      String? city,
      String? country}) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/updateClient'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "email": email.toString(),
              "fname": fname.toString(),
              "lname": lname.toString(),
              "birthdate": birthdate.toString(),
              "sex": sex.toString(),
              "street": street.toString(),
              "postCode": postCode.toString(),
              "city": city.toString(),
              "country": country.toString(),
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  ///******************** PAYMENTS *******************///
  /// API calls needed for payment related operations ///
  ///*************************************************///
  Future<String> selectClientPaymentHistory({String? email}) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/selectClientPaymentHistory'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{"email": email.toString()}),
          )
          .timeout(const Duration(seconds: 2));
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> finalizeClientPayment(String? email, String? modality,
      String? amount, String? transID, String? doneDate) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/finalizeClientPayment'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "email": email.toString(),
              "modality": modality.toString(),
              "amount": amount.toString(),
              "transID": transID.toString(),
              "doneDate": doneDate.toString(),
            }),
          )
          .timeout(const Duration(seconds: 2));
      return response.body;
    } on Exception {
      return "ERROR";
    }
  }

  ///******************** INSTRUCTORS *******************///
  /// API calls needed for instructor related operations ///
  ///****************************************************///
  Future<String> selectAvailableInstructors() async {
    try {
      final response = await http.post(
        Uri.parse(deployedAPI + '/selectAvailableInstructors'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
      ).timeout(const Duration(seconds: 2));

      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> associateInstructor(
      String? clientEmail, String? instructorEmail) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/associateInstructor'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "clientEmail": clientEmail.toString(),
              "instructorEmail": instructorEmail.toString(),
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (jsonDecode((response.body))["code"] == 0) {
        var formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(DateTime.now());
        SharedPreferencesHelper().saveStringToSF("isAssociated", "yes");
        SharedPreferencesHelper()
            .saveStringToSF("associatedInstructor", instructorEmail!);
        SharedPreferencesHelper()
            .saveStringToSF("associatedDate", formattedDate);
      }
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> isClientAssociated({String? email}) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/isClientAssociated'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "email": email.toString(),
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (jsonDecode((response.body))["code"] != 1) {
        SharedPreferencesHelper().saveStringToSF(
            "isAssociated", jsonDecode((response.body))["isAssociated"]);
        SharedPreferencesHelper().saveStringToSF(
            "associatedDate", jsonDecode((response.body))["associatedDate"]);
        SharedPreferencesHelper().saveStringToSF("associatedInstructor",
            jsonDecode((response.body))["associatedInstructor"]);
      }
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> selectAssociatedInstructor({String? email}) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/selectAssociatedInstructor'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "email": email.toString(),
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> reviewAssociatedInstructor(
      {String? clientEmail,
      String? instructorEmail,
      num? rating,
      String? review}) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/clientReviewInstructor'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "clientEmail": clientEmail.toString(),
              "instructorEmail": instructorEmail.toString(),
              "rating": rating.toString(),
              "review": review.toString(),
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> removeInstructorAssociation({String? email}) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/removeInstructorAssociation'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "email": email.toString(),
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (jsonDecode((response.body))["code"] == 0) {
        SharedPreferencesHelper().saveStringToSF(
            "isAssociated", jsonDecode((response.body))["isAssociated"]);
        SharedPreferencesHelper().saveStringToSF(
            "associatedDate", jsonDecode((response.body))["associatedDate"]);
        SharedPreferencesHelper().saveStringToSF("associatedInstructor",
            jsonDecode((response.body))["associatedInstructor"]);
      }
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> selectClientInstructorHistory({String? email}) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/selectClientInstructorHistory'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "email": email.toString(),
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  ///********************* FREE CONTENT *******************///
  /// API calls needed for free content related operations ///
  ///******************************************************///
  Future<String> selectDefaultExercises() async {
    try {
      final response = await http.post(
        Uri.parse(deployedAPI + '/selectDefaultExercises'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
      ).timeout(const Duration(seconds: 2));
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> selectDefaultPrograms() async {
    try {
      final response = await http.post(
        Uri.parse(deployedAPI + '/selectDefaultPrograms'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
      ).timeout(const Duration(seconds: 2));
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  ///********************* PREMIUM CONTENT ****************///
  /// API calls needed for premium related operations      ///
  ///******************************************************///
  Future<String> selectClientPrograms({String? email}) async {
    try {
      final response = await http
          .post(
            Uri.parse(deployedAPI + '/selectClientPrograms'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "email": email.toString(),
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> selectAllProgramExercises() async {
    try {
      final response = await http.post(
        Uri.parse(deployedAPI + '/selectAllProgramExercises'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
      ).timeout(const Duration(seconds: 2));
      if (response.ok) {
        return response.body;
      } else {
        return "ERROR";
      }
    } on Exception {
      return "ERROR";
    }
  }
}

/* Extension method to check if response is sucessfull (any status code between 200-299) */
extension IsOk on http.Response {
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}

/* Calculate days difference between two dates */
int daysBetween(String paid, String plan) {
  if (plan == "" || paid == "") {
    return 0;
  } else {
    var formattedString = DateTime.parse(paid);
    var from = DateTime(
        formattedString.year, formattedString.month, formattedString.day);
    DateTime to;
    if (plan == "Monthly" || plan == "monthly") {
      to = DateTime(
          formattedString.year, formattedString.month + 1, formattedString.day);
    } else {
      to = DateTime(
          formattedString.year + 1, formattedString.month, formattedString.day);
    }
    return (to.difference(from).inHours / 24).round();
  }
}
