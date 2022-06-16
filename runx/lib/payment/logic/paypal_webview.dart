// Ssytem Packaes
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:runx/payment/screens/payment_success.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Logic
import 'package:runx/payment/logic/paypal_services.dart';

// Screens
import 'package:runx/payment/screens/payment_error.dart';

class PaypalPayment extends StatefulWidget {
  final String pModality;
  final String pAmount;
  final String email;

  const PaypalPayment(
      {Key? key,
      required this.pModality,
      required this.pAmount,
      required this.email})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl = "";
  String executeUrl = "";
  String accessToken = "";
  PaypalServices services = PaypalServices();

  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "EUR ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "EUR"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = (await services.getAccessToken())!;
        if (accessToken == "ERROR") {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Ocorreu um erro. Verifique a sua conexão ou tente mais tarde",
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        } else {
          final transactions = getOrderParams();
          final res =
              await services.createPaypalPayment(transactions, accessToken);
          if (res != null && !res.containsKey("ERROR")) {
            setState(() {
              checkoutUrl = res["approvalUrl"]!;
              executeUrl = res["executeUrl"]!;
            });
          } else {
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Ocorreu um erro. Verifique a sua conexão ou tente mais tarde",
                style: TextStyle(fontSize: 16),
              ),
            ));
          }
        }
      } catch (e) {
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Ocorreu um erro. Verifique a sua conexão ou tente mais tarde",
            style: TextStyle(fontSize: 16),
          ),
        ));
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != "") {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                services
                    .executePayment(executeUrl, payerID, accessToken,
                        widget.email, widget.pAmount, widget.pModality)
                    .then((id) {
                  if (id == "ERROR") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentError(
                          title: 'Erro de Pagamento',
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentSuccess(
                          title: 'Pagamento com Sucesso',
                        ),
                      ),
                    );
                  }
                });
              } else {
                Navigator.of(context).pop();
              }
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.prevent;
          },
        ),
      );
    } else {
      return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            backgroundColor: Colors.black12,
            elevation: 0.0,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200.0,
                child: Stack(
                  children: const <Widget>[
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    Center(child: Text("A conectar a Paypal.com")),
                  ],
                ),
              ),
            ],
          ));
    }
  }

  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": widget.pModality.toString() + " Plan",
        "quantity": 1,
        "price": widget.pAmount.toString(),
        "currency": defaultCurrency["currency"]
      }
    ];

    // Checkout invoice details in format as requested by Paypal
    String totalAmount = widget.pAmount.toString();
    String subTotalAmount = widget.pAmount.toString();
    String shippingCost = "0";
    int shippingDiscountCost = 0;
    String userFirstName = "";
    String userLastName = "";
    String addressCity = "";
    String addressStreet = "";
    String addressZipCode = "";
    String addressCountry = "";
    String addressState = "";
    String addressPhoneNumber = "";

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "Purchase of a " + widget.pModality + " plan in RunX",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName + " " + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }
}
