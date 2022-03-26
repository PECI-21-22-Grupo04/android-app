// System Packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Logic
import 'package:runx/api.dart';

// Screens
import 'package:runx/presentation/page_nav.dart';

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
              Text('Forneça informação adicional ao seu instrutor',
                  style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
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
                  'Poderá alterar esta informação mais tarde no seu perfil',
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

  String fitnesslevel = 'Principiante';

  var items = [
    'Principiante',
    'Elementar',
    'Intermédio',
    'Avançado',
    'Atleta',
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
                labelText: 'Idade (anos)',
                prefixIcon: const Icon(Icons.calendar_month_rounded),
                border: border,
              ),
              onSaved: (val) {
                age = val;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor introduza a sua idade';
                }
                if (int.parse(value) > 120 || int.parse(value) < 16) {
                  return "Tem de ter mais de 16 anos para se registar";
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
                labelText: 'Altura (cm)',
                prefixIcon: const Icon(Icons.man_rounded),
                border: border,
              ),
              onSaved: (val) {
                height = val;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor introduza a sua altura';
                }
                if (int.parse(value) > 250 || int.parse(value) < 100) {
                  return "Por favor introduza uma altura válida";
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
                  labelText: 'Peso (kg)',
                  prefixIcon: const Icon(Icons.monitor_weight_rounded),
                  border: border),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor introduza o seu peso';
                }
                if (int.parse(value) > 200 || int.parse(value) < 30) {
                  return "Por favor introduza um peso válido";
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
                LengthLimitingTextInputFormatter(300),
              ],
              decoration: InputDecoration(
                labelText: 'Patologias, outra informação...',
                prefixIcon: const Icon(Icons.local_hospital_rounded),
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
              const Text('Nível de Fitness', style: TextStyle(fontSize: 30)),
              DropdownButton(
                style: const TextStyle(fontSize: 20, color: Colors.black),
                value: fitnesslevel,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
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
                      .addClientInfo(
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
                'Submeter Informação',
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
                'Saltar',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
