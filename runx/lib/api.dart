// System Packages
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

// Logic
import 'package:runx/caching/sharedpref_helper.dart';

class APICaller {
  final String host = 'http://localhost:';
  final String port = '8080';

  ///***************** AUTHENTICATION ******************///
  /// API calls needed for authentication operations    ///
  ///***************************************************///
  Future<String> selectClient({String? email}) async {
    try {
      final response = await http
          .post(
            Uri.parse(host + port + '/selectClient'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "email": email.toString(),
            }),
          )
          .timeout(const Duration(seconds: 2));

      if (jsonDecode((response.body))["code"] == 0) {
        try {
          final response2 = await http
              .post(
                Uri.parse(host + port + '/selectLatestClientPayment'),
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
            SharedPreferencesHelper().saveStringToSF(
                "paidDate",
                jsonDecode((response2.body))["paidDate"]
                    .toString()
                    .split(" ")[0]);
            SharedPreferencesHelper().saveStringToSF(
                "accountStatus", jsonDecode((response2.body))["accountStatus"]);
            SharedPreferencesHelper()
                .saveStringToSF("plan", jsonDecode((response2.body))["plan"]);
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
            Uri.parse(host + port + '/createClient'),
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
            .post(Uri.parse(host + port + '/deleteClient'),
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
              Uri.parse(host + port + '/updateFirebaseID'),
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
            Uri.parse(host + port + '/addClientInfo'),
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
            Uri.parse(host + port + '/finishWorkout'),
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
            Uri.parse(host + port + '/selectClientWorkoutHistory'),
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

  ///******************** PAYMENTS *******************///
  /// API calls needed for payment related operations ///
  ///*************************************************///
  Future<String> selectClientPaymentHistory({String? email}) async {
    try {
      final response = await http
          .post(
            Uri.parse(host + port + '/selectClientPaymentHistory'),
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

  Future<String> finalizeClientPayment(
      String? email, String? modality, String? amount, String? transID) async {
    try {
      final response = await http
          .post(
            Uri.parse(host + port + '/finalizeClientPayment'),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: (<String, String>{
              "email": email.toString(),
              "modality": modality.toString(),
              "amount": amount.toString(),
              "transID": transID.toString(),
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
        Uri.parse(host + port + '/selectAvailableInstructors'),
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
            Uri.parse(host + port + '/associateInstructor'),
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
            Uri.parse(host + port + '/isClientAssociated'),
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
            Uri.parse(host + port + '/selectAssociatedInstructor'),
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
            Uri.parse(host + port + '/clientReviewInstructor'),
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
            Uri.parse(host + port + '/removeInstructorAssociation'),
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
            Uri.parse(host + port + '/selectClientInstructorHistory'),
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
        Uri.parse(host + port + '/selectDefaultExercises'),
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
        Uri.parse(host + port + '/selectDefaultPrograms'),
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
            Uri.parse(host + port + '/selectClientPrograms'),
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
        Uri.parse(host + port + '/selectAllProgramExercises'),
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
