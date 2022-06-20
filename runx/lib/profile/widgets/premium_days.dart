// System Packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildPremiumCountdown(String paidDate, String plan) {
  return Text(
    "Conta Premium - " +
        daysBetween(DateFormat('yyyy-MM-dd').parse(paidDate), plan).toString() +
        " dias restantes",
    style: const TextStyle(
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
  );
}

int daysBetween(DateTime paid, String plan) {
  var from = DateTime(paid.year, paid.month, paid.day);
  DateTime to;
  if (plan == "Monthly" || plan == "monthly") {
    to = DateTime(paid.year, paid.month + 1, paid.day);
  } else {
    to = DateTime(paid.year + 1, paid.month, paid.day);
  }
  return (to.difference(from).inHours / 24).round();
}
