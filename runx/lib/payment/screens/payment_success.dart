// System Packages
import 'package:flutter/material.dart';

// Widgets
import 'package:runx/payment/widgets/button_profile.dart';

// Screens
import 'package:runx/presentation/bottom_nav.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
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
              height: 170,
              padding: const EdgeInsets.all(35),
              decoration: const BoxDecoration(
                color: Color(0xFF43D19E),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/images/payment_success.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            const Text(
              "Obrigado!",
              style: TextStyle(
                color: Color(0xFF43D19E),
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              "Pagamento Realizado com Sucesso",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            const Text(
              "Possui agora uma conta premium\nDisfrute de todas as features da aplicação",
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
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const BottomNav()),
                        (Route<dynamic> route) => false);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
