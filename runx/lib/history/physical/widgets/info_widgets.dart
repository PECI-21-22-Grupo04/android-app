// System Packages
import 'package:flutter/material.dart';

// Models
import 'package:runx/caching/models/physical_data.dart';

Widget getWidgetWeight(List<PhysicalData> physicalData) {
  if (physicalData.length == 1) {
    return Text(
      "   Peso: " + physicalData.elementAt(0).weight.toString() + "kg",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  } else {
    if (physicalData.elementAt(0).weight > physicalData.elementAt(1).weight) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "   Peso: " +
                  physicalData.elementAt(0).weight.toString() +
                  "kg",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const WidgetSpan(
              child: Icon(
                Icons.keyboard_double_arrow_up_rounded,
                color: Color.fromARGB(255, 16, 76, 180),
              ),
            ),
          ],
        ),
      );
    } else if (physicalData.elementAt(0).weight <
        physicalData.elementAt(1).weight) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "   Peso: " +
                  physicalData.elementAt(0).weight.toString() +
                  "kg",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const WidgetSpan(
              child: Icon(
                Icons.keyboard_double_arrow_down_rounded,
                color: Color.fromARGB(255, 16, 76, 180),
              ),
            ),
          ],
        ),
      );
    } else {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "   Peso: " + physicalData.elementAt(0).weight.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const WidgetSpan(
              child: Icon(
                Icons.keyboard_double_arrow_left_rounded,
                color: Color.fromARGB(255, 16, 76, 180),
              ),
            ),
          ],
        ),
      );
    }
  }
}

Widget getWidgetIMC(List<PhysicalData> physicalData) {
  if (physicalData.length == 1) {
    return Text(
      "   IMC: " + physicalData.elementAt(0).bmi.toString(),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  } else {
    if (physicalData.elementAt(0).bmi > physicalData.elementAt(1).bmi) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "   IMC: " + physicalData.elementAt(0).bmi.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const WidgetSpan(
              child: Icon(
                Icons.keyboard_double_arrow_up_rounded,
                color: Color.fromARGB(255, 16, 76, 180),
              ),
            ),
          ],
        ),
      );
    } else if (physicalData.elementAt(0).bmi < physicalData.elementAt(1).bmi) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "   IMC: " + physicalData.elementAt(0).bmi.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const WidgetSpan(
              child: Icon(
                Icons.keyboard_double_arrow_down_rounded,
                color: Color.fromARGB(255, 16, 76, 180),
              ),
            ),
          ],
        ),
      );
    } else {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "   IMC: " + physicalData.elementAt(0).bmi.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const WidgetSpan(
              child: Icon(
                Icons.keyboard_double_arrow_left_rounded,
                color: Color.fromARGB(255, 16, 76, 180),
              ),
            ),
          ],
        ),
      );
    }
  }
}
