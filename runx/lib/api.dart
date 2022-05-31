// System Packages
import 'dart:async';
import 'package:http/http.dart' as http;

class APICaller {
  final String host = 'http://localhost:';
  final String port = '8080';

  /// ***************** REGISTER/LOGIN ***************** ///
  /// API calls needed for register and login operations ///
  /// ************************************************** ///

  Future<String> selectClient({String? email}) async {
    try {
      final response = await http.post(
        Uri.parse(host + port + '/selectClient'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: (<String, String>{
          "email": email.toString(),
        }),
      );
      return response.body;
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
      final response = await http.post(
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
      );
      return response.body;
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> deleteClient({String? email}) async {
    try {
      final response = await http.post(
        Uri.parse(host + port + '/deleteClient'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: (<String, String>{
          "email": email.toString(),
        }),
      );
      return response.body;
    } on Exception {
      return "ERROR";
    }
  }

// Save Client Information
  Future<String> addClientInfo(
      {String? email,
      String? height,
      String? weight,
      String? fitness,
      String? bmi,
      String? pathologies}) async {
    try {
      final response = await http.post(
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
      );
      return response.body;
    } on Exception {
      return "ERROR";
    }
  }

  /// ******************** PAYMENTS ******************** ///
  /// API calls needed for payment related operations    ///
  /// ************************************************** ///

  Future<String> selectClientPaymentHistory({String? email}) async {
    try {
      final response = await http.post(
        Uri.parse(host + port + '/selectClientPaymentHistory'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: (<String, String>{"email": email.toString()}),
      );
      return response.body;
    } on Exception {
      return "ERROR";
    }
  }

  Future<String> finalizeClientPayment(
      String? email, String? modality, String? amount, String? transID) async {
    try {
      final response = await http.post(
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
      );
      return response.body;
    } on Exception {
      return "ERROR";
    }
  }

  /// ******************** INSTRUCTORS ***************** ///
  /// API calls needed for instructor related operations ///
  /// ************************************************** ///

  Future<String> selectAvailableInstructors() async {
    try {
      final response = await http.post(
        Uri.parse(host + port + '/selectAvailableInstructors'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
      );
      return response.body;
    } on Exception {
      return "ERROR";
    }
  }

  /// ******************** FREE CONTENT **************** ///
  /// API calls needed for providing free content        ///
  /// (programs and exercies)                            ///
  /// ************************************************** ///

  Future<String> selectDefaultExercises() async {
    try {
      final response = await http.post(
        Uri.parse(host + port + '/selectDefaultExercises'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
      );
      return response.body;
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
      );
      return response.body;
    } on Exception {
      return "ERROR";
    }
  }
}
