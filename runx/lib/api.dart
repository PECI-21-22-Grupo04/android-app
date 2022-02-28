// System Packages
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIHelper {
// Create User with basic info -> Email, First Name and Last Name
  Future<http.Response> createUser(
      {String? email, String? fname, String? lname}) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/createUser'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        "Email": email.toString(),
        "fname": fname.toString(),
        "lname": lname.toString(),
      }),
    );
    return response;
  }
}
