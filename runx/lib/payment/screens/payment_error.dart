// System Packages
import 'package:flutter/material.dart';

// Widgets
import 'package:runx/payment/widgets/button_profile.dart';

class PaymentError extends StatefulWidget {
  const PaymentError({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PaymentError> createState() => _PaymentErrorState();
}

class _PaymentErrorState extends State<PaymentError> {
  double screenWidth = 600;
  double screenHeight = 400;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/images/payment_error.png",
                fit: BoxFit.fill,
              ),
            ),
            const Text(
              "Ocorreu um erro!",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              "Pagamento Cancelado",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            const Text(
              "Ocorreu um erro durante o pagamento\nNão será cobrado qualquer valor da sua conta",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: screenHeight * 0.06),
            Flexible(
              child: ProfileButton(
                title: 'Entendido',
                onTap: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 3);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
