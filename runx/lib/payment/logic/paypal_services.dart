// System Packages
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:http_auth/http_auth.dart';
import 'package:intl/intl.dart';

// Logic
import 'package:runx/api.dart';
import 'package:runx/caching/sharedpref_helper.dart';

class PaypalServices {
  String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
  //String domain = "https://api.paypal.com"; // for production mode

  // ClientId and Secret, provided by Paypal
  String clientId =
      'AaUcJJIFmro9A-NiT-X7T3no0oqohDmb5wwOBd_bIjHcljSd-pEid-SqRcPUuYZgt9jyAvE-aZso6oVk';
  String secret =
      'EOLeLYsBMpbqz-De3ZRyQs27VfVr8uqcECoHw60IVQg58v8Qf41ypaB5oXYLpt0zftBzxHXQdgco0CWQ';

  // Get access token from Paypal
  Future<String?> getAccessToken() async {
    try {
      var client = BasicAuthClient(clientId, secret);
      var response = await client.post(
          Uri.parse(domain + '/v1/oauth2/token?grant_type=client_credentials'));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body["access_token"];
      } else {
        return "ERROR";
      }
    } catch (e) {
      return "ERROR";
    }
  }

  // Create the payment request with Paypal
  Future<Map<String, String>?> createPaypalPayment(
      transactions, accessToken) async {
    try {
      final response = await http.post(
        Uri.parse(domain + '/v1/payments/payment'),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': 'Bearer ' + accessToken
        },
        body: jsonEncode(transactions),
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        return {"ERROR": "ERROR"};
      }
    } catch (e) {
      return {"ERROR": "ERROR"};
    }
  }

  // Execute the payment transaction
  Future<String?> executePayment(
      url, payerId, accessToken, email, amount, modality) async {
    try {
      var response = await http.post(Uri.parse(url),
          body: jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body["state"] == "approved") {
        // Save payment in database
        APICaller().finalizeClientPayment(email, modality, amount, body["id"]);
        // Change account status to premium
        var formatter = DateFormat('dd-MM-yyyy');
        String formattedDate = formatter.format(DateTime.now());
        SharedPreferencesHelper().saveStringToSF("paidDate", formattedDate);
        SharedPreferencesHelper().saveStringToSF("accountStatus", "premium");
        SharedPreferencesHelper().saveStringToSF("plan", modality.toString());
        return body["id"];
      } else {
        return "ERROR";
      }
    } catch (e) {
      return "ERROR";
    }
  }
}
