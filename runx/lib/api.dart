// System Packages
import 'dart:async';
import 'package:http/http.dart' as http;

class APICaller {
  final String host = 'http://localhost:';
  final String port = '8080';

// Create Client
  Future<String> createClient(
      {String? email, String? fname, String? lname}) async {
    final response = await http.post(
      Uri.parse(host + port + '/createClient'),
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

// Delete Client
  Future<String> deleteClient({String? email}) async {
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
  }

// Save Client Information
  Future<String> addClientInfo(
      {String? email,
      String? age,
      String? height,
      String? weight,
      String? fitness,
      String? pathologies}) async {
    final response = await http.post(
      Uri.parse(host + port + '/addClientInfo'),
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
