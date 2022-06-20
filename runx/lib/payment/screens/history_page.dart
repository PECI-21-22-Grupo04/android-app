// System Packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
import 'package:runx/caching/models/payment.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ValueListenableBuilder<Box>(
          valueListenable: Hive.box("PaymentHistory").listenable(),
          builder: (context, box, _) {
            final payments = box.values.toList().cast<Payment>();
            payments.sort((a, b) => a.paymentID.compareTo(b.paymentID));
            return buildContent(payments);
          },
        ),
      );

  Widget buildContent(List<Payment> payments) {
    if (payments.isEmpty) {
      return const Center(
        child: Center(
          child: Text(
            'Não conseguimos encontrar pagamentos efetuados!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ),
        ),
      );
    }
    return Column(
      children: [
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: payments.length,
            itemBuilder: (BuildContext context, int index) {
              final transaction = payments[index];
              return buildTransaction(context, transaction);
            },
          ),
        ),
      ],
    );
  }

  Widget buildTransaction(BuildContext context, Payment payments) {
    const color = Colors.green;
    final amount = '€' + payments.amount;

    return Card(
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        title: Text(
          "ID: " +
              payments.paymentID.toString() +
              " - " +
              "Pagamento " +
              payments.getModality() +
              "\n",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text("Realizado: " + payments.paymentDate),
        trailing: Text(
          amount,
          style: const TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
