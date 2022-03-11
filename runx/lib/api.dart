// System Packages
import 'dart:async';
import 'package:http/http.dart' as http;

class APICaller {
  final String host = 'http://localhost:';
  final String port = '8080';

// Create User
  Future<String> createUser(
      {String? email, String? fname, String? lname}) async {
    final response = await http.post(
      Uri.parse(host + port + '/createUser'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
      },
      body: (<String, String>{
        "email": email.toString(),
        "fname": fname.toString(),
        "lname": lname.toString(),
      }),
    );
    return response.body;
  }

// Delete User
  Future<String> deleteUser({String? email}) async {
    final response = await http.post(
      Uri.parse(host + port + '/deleteUser'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
      },
      body: (<String, String>{
        "email": email.toString(),
      }),
    );
    return response.body;
  }

// Save User Information
  Future<String> addUserInfo(
      {String? email,
      String? age,
      String? height,
      String? weight,
      String? fitness,
      String? pathologies}) async {
    final response = await http.post(
      Uri.parse(host + port + '/addUserInfo'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
      },
      body: (<String, String>{
        "email": email.toString(),
        "age": age.toString(),
        "height": height.toString(),
        "weight": weight.toString(),
        "fitness": fitness.toString(),
        "pathologies": pathologies.toString(),
      }),
    );
    return response.body;
  }
}
