// System Packages
import 'package:hive/hive.dart';

// Generate Hive Model Adapter
part 'payment.g.dart';

@HiveType(typeId: 2)
class Payment extends HiveObject {
  @HiveField(0)
  final int paymentID;

  @HiveField(1)
  final String modality;

  @HiveField(2)
  final String amount;

  @HiveField(3)
  final String paymentDate;

  Payment(
      {required this.paymentID,
      required this.modality,
      required this.amount,
      required this.paymentDate});

  factory Payment.fromJson(Map<String, dynamic> parsedJson) {
    return Payment(
        paymentID: parsedJson['paymentID'],
        modality: parsedJson['modality'],
        amount: parsedJson['amount'].toString(),
        paymentDate: parsedJson['paymentDate']);
  }

  int getPaymentID() {
    return paymentID;
  }

  String getModality() {
    if (modality == "Monthly") {
      return "Mensal";
    } else {
      return "Anual";
    }
  }

  String getAmount() {
    return amount;
  }

  String getPaymentDate() {
    List<String> parsedDate = paymentDate.split("-");
    return parsedDate[2] + "/" + parsedDate[1] + "/" + parsedDate[0];
  }
}
