// System Packages
import 'package:flutter/material.dart';

// Screens
import 'package:runx/payment/screens/history_page.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({Key? key}) : super(key: key);

  @override
  _PaymentHistory createState() => _PaymentHistory();
}

class _PaymentHistory extends State<PaymentHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Pagamentos')),
      body: buildPaymentHistory(),
    );
  }

  Widget buildPaymentHistory() {
    return const TransactionPage();
  }
}
