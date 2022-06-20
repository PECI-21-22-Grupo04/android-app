// System Packages
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
import 'package:runx/caching/models/physical_data.dart';

// Logic
import 'package:runx/api.dart';
import 'package:runx/caching/hive_helper.dart';

// Screens
import 'package:runx/history/physical/physical_history.dart';

class AddInfoHealth extends StatelessWidget {
  final PhysicalData? latestData;

  const AddInfoHealth({Key? key, required this.latestData}) : super(key: key);

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
              Text('Atualize a sua informação fisica',
                  style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SignupForm(
              latestDataC: latestData,
              emailC: FirebaseAuth.instance.currentUser!.email,
            ),
          ),
        ],
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  final String? emailC;
  final PhysicalData? latestDataC;

  const SignupForm({Key? key, required this.emailC, required this.latestDataC})
      : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  Box userInfo = Hive.box("UserProfile");
  final _formKey = GlobalKey<FormState>();

  String? heightC;
  String? weightC;
  String? pathologiesC;
  late String fitnesslevelC;

  List<String> listOfLevels = ['Elementar', 'Intermédio', 'Avançado'];

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
              initialValue: widget.latestDataC!.height.toString(),
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
              initialValue: widget.latestDataC!.weight.toString(),
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
            initialValue: userInfo
                .get(FirebaseAuth.instance.currentUser!.email)
                .getPathologies(),
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
                      .then(
                    (result) {
                      // If result code is 0, the data has been successfully saved in the database
                      if (result != "ERROR" &&
                          json.decode(result)["code"] == 0) {
                        APICaller()
                            .selectClientInfo(
                                email: FirebaseAuth.instance.currentUser!.email)
                            .then((clientInfo) {
                          if (clientInfo != "ERROR" &&
                              json.decode(clientInfo)["code"] == 0 &&
                              json.decode(clientInfo)["data"] != null) {
                            // 2º - Convert json received to objects
                            List<PhysicalData> itemsList =
                                List<PhysicalData>.from(json
                                    .decode(clientInfo)["data"][0]
                                    .map((i) => PhysicalData.fromJson(i)));
                            // 3º - Save in Hive for caching
                            for (PhysicalData p in List.from(itemsList)) {
                              HiveHelper().addToBox(
                                  p, "PhysicalHistory", p.dataID.toString());
                            }
                          }
                        });
                        sleep(const Duration(milliseconds: 200));
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PhysicalHistory()),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          duration: Duration(seconds: 3),
                          content: Text(("Os seus dados foram guardados!"),
                              style: TextStyle(fontSize: 16)),
                        ));
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
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                ("Ocorreu um erro \nVerifique a sua conexão ou tente mais tarde"),
                                style: TextStyle(fontSize: 16)),
                          ));
                        }
                      }
                    },
                  );
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
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              child: const Text(
                'Cancelar',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
