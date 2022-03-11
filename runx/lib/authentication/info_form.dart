// System Packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Logic
import 'package:runx/api.dart';

// Screens
import 'package:runx/user_profile/page_nav.dart';

class InfoForm extends StatelessWidget {
  final String? emailP;
  final String? fnameP;
  final String? lnameP;

  const InfoForm(
      {Key? key,
      required this.emailP,
      required this.fnameP,
      required this.lnameP})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const SizedBox(height: 20),
          Column(
            children: const [
              SizedBox(height: 20),
              Text(
                  'Additional information that may be helpful to your instructor',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SignupForm(
              emailC: emailP,
              fnameC: fnameP,
              lnameC: lnameP,
            ),
          ),
          const SizedBox(height: 30),
          const Expanded(
              child: Text(
                  'You may alter this information later on your profile page.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  final String? fnameC;
  final String? lnameC;
  final String? emailC;

  const SignupForm(
      {Key? key,
      required this.emailC,
      required this.fnameC,
      required this.lnameC})
      : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  String? age;
  String? height;
  String? weight;
  String? pathologies;

  String fitnesslevel = 'Begginer';

  var items = [
    'Begginer',
    'Elementary',
    'Intermediate',
    'Advanced',
    'Athlete',
  ];

  final pass = TextEditingController();

  get fname => widget.fnameC;
  get lname => widget.lnameC;
  get email => widget.emailC;

  @override
  Widget build(BuildContext context) {
    var border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(100.0),
      ),
    );

    var space = const SizedBox(height: 10);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // Age
          TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(3),
              ],
              decoration: InputDecoration(
                labelText: 'Age (years)',
                prefixIcon: const Icon(Icons.calendar_month),
                border: border,
              ),
              onSaved: (val) {
                age = val;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Your Age';
                }
                if (int.parse(value) > 120 || int.parse(value) < 14) {
                  return "Please Enter a Valid Age";
                }
                return null;
              },
              keyboardType: TextInputType.number),
          space,

          // Height
          TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(3),
              ],
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                prefixIcon: const Icon(Icons.man),
                border: border,
              ),
              onSaved: (val) {
                height = val;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Your Height';
                }
                if (int.parse(value) > 250 || int.parse(value) < 100) {
                  return "Please Enter a Valid Height";
                }
                return null;
              },
              keyboardType: TextInputType.number),
          space,

          // Weight
          TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(3),
              ],
              decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: const Icon(Icons.monitor_weight),
                  border: border),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Your Weight';
                }
                if (int.parse(value) > 200 || int.parse(value) < 25) {
                  return "Please Enter a Valid Weight";
                }
                return null;
              },
              onSaved: (val) {
                weight = val;
              },
              keyboardType: TextInputType.number),
          space,

          // Pathologies
          TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(250),
              ],
              decoration: InputDecoration(
                labelText: 'Pathologies, other info...',
                prefixIcon: const Icon(Icons.local_hospital),
                border: border,
                contentPadding: const EdgeInsets.symmetric(vertical: 50.0),
              ),
              onSaved: (val) {
                pathologies = val;
              },
              keyboardType: TextInputType.text),
          space,
          space,

          // Fitness Level
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Fitness Level', style: TextStyle(fontSize: 30)),
              DropdownButton(
                style: const TextStyle(fontSize: 20, color: Colors.black),
                value: fitnesslevel,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    fitnesslevel = newValue!;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Submit Information Button
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Save additional user information in the database
                  APICaller()
                      .addUserInfo(
                          email: email,
                          age: age,
                          height: height,
                          weight: weight,
                          fitness: fitnesslevel,
                          pathologies: pathologies)
                      .then((result) {
                    // If result code is 0, the data has been successfully saved in the database
                    if (json.decode(result)["code"] == 0) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PageNav()));
                    }
                    // Else show error message
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          json.decode(result)["code"],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ));
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              child: const Text(
                'Submit Info',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          space,
          space,

          // Skip Information Button
          SizedBox(
            height: 50,
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const PageNav()));
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              child: const Text(
                'Skip',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
