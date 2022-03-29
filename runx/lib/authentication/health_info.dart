// System Packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Logic
import 'package:runx/api.dart';

// Screens
import 'package:runx/presentation/page_nav.dart';

class HealthInfoForm extends StatelessWidget {
  final String? emailP;
  final String? fnameP;
  final String? lnameP;

  const HealthInfoForm(
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
              Text('Informação fisica adicional',
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

  String? heightC;
  String? weightC;
  String? pathologiesC;
  late String fitnesslevelC;

  List<String> listOfLevels = ['Elementar', 'Intermédio', 'Avançado'];

  get fname => widget.fnameC;
  get lname => widget.lnameC;
  get email => widget.emailC;

  @override
  Widget build(BuildContext context) {
    var space = const SizedBox(height: 10);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // Height
          TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(3),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Altura (cm)',
                icon: Icon(Icons.man_rounded),
              ),
              onSaved: (val) {
                heightC = val;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor introduza a sua altura';
                }
                if (int.parse(value) > 250 || int.parse(value) < 120) {
                  return "Por favor introduza uma altura válida (120cm a 250cm)";
                }
                return null;
              },
              keyboardType: TextInputType.number),
          space,

          // Weight
          TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(3),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  icon: Icon(Icons.monitor_weight_rounded)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor introduza o seu peso';
                }
                if (int.parse(value) > 200 || int.parse(value) < 25) {
                  return "Por favor introduza um peso válido (25kg a 200kg)";
                }
                return null;
              },
              onSaved: (val) {
                weightC = val;
              },
              keyboardType: TextInputType.number),
          space,

          // Fitness Level
          DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Nível de Fitness',
              icon: Icon(Icons.show_chart_rounded),
              hintText: "Escolha uma opção",
            ),
            isExpanded: true,
            onChanged: (value) {
              setState(() {
                fitnesslevelC = value.toString();
              });
            },
            onSaved: (value) {
              setState(() {
                fitnesslevelC = value.toString();
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Por favor introduza o seu nivel de fitness';
              }
              return null;
            },
            items: listOfLevels.map((String fitnesslevelC) {
              return DropdownMenuItem(
                  value: fitnesslevelC, child: Text(fitnesslevelC));
            }).toList(),
          ),
          space,

          // Pathologies
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Patologias',
                icon: Icon(Icons.local_hospital_rounded),
                hintText: "Patologias, outra informação"),
            onSaved: (value) => pathologiesC = value!,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            maxLength: 250,
          ),
          space,
          space,
          space,
          space,

          // Submit Information Button
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  int formulaVal1 = (int.parse(weightC!));
                  double formulaVal2 = ((int.parse(heightC!) / 100) *
                      (int.parse(heightC!) / 100));

                  // Save additional user information in the database
                  APICaller()
                      .addClientInfo(
                          email: email,
                          height: heightC,
                          weight: weightC,
                          fitness: fitnesslevelC,
                          bmi: (formulaVal1 / formulaVal2)
                              .toString(), // BMI formula is weight(kg)/height(m)^2
                          pathologies: pathologiesC)
                      .then((result) {
                    // If result code is 0, the data has been successfully saved in the database
                    if (result != "ERROR" && json.decode(result)["code"] == 0) {
                      Navigator.pushAndRemoveUntil<void>(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const PageNav()),
                          (Route<dynamic> route) => false);
                    }
                    // Else show error message
                    else {
                      if (result == "ERROR") {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              ("Ocorreu um erro \nVerifique a sua conexão ou tente mais tarde"),
                              style: TextStyle(fontSize: 16)),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text((json.decode(result)["code"]),
                              style: const TextStyle(fontSize: 16)),
                        ));
                      }
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
