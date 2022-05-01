// System Packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';

// Logic
import 'package:runx/authentication/firebase.dart';
import 'package:runx/api.dart';
import 'package:runx/caching/models/user_profile.dart';

// Screens
import 'package:runx/authentication/screens/health_info.dart';
import 'package:runx/caching/hive_helper.dart';

class LegalInfo extends StatelessWidget {
  final String? emailP;
  final String? fnameP;
  final String? lnameP;
  final String? passwP;

  const LegalInfo(
      {Key? key,
      required this.emailP,
      required this.fnameP,
      required this.lnameP,
      required this.passwP})
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
              Text('Informações Pessoais',
                  style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SignupForm(
              emailC: emailP,
              fnameC: fnameP,
              lnameC: lnameP,
              passC: passwP,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  final String? fnameC;
  final String? lnameC;
  final String? emailC;
  final String? passC;

  const SignupForm(
      {Key? key,
      required this.emailC,
      required this.fnameC,
      required this.lnameC,
      required this.passC})
      : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  late String sexC;
  late String birthdateC;
  late String streetC;
  late String postCodeC;
  late String cityC;
  String countryC = "";
  List<String> listOfSexes = ['Masculino', 'Feminino', 'Outro'];

  get fname => widget.fnameC;
  get lname => widget.lnameC;
  get email => widget.emailC;
  get pass => widget.passC;

  @override
  Widget build(BuildContext context) {
    TextEditingController _countryController = TextEditingController();
    _countryController.text = countryC;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // Sex
          DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Género',
              icon: Icon(Icons.account_circle_rounded),
              hintText: "Escolha uma opção",
            ),
            isExpanded: true,
            onChanged: (value) {
              setState(() {
                sexC = value.toString();
              });
            },
            onSaved: (value) {
              setState(() {
                sexC = value.toString();
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Por favor introduza o seu sexo';
              }
              return null;
            },
            items: listOfSexes.map((String sex) {
              return DropdownMenuItem(value: sex, child: Text(sex));
            }).toList(),
          ),

          // Birthdate
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Data de Nascimento',
              icon: Icon(Icons.calendar_today_outlined),
              hintText: "dd/mm/aaaa",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor introduza a sua data de nascimento';
              }
              try {
                String dateStr = value;
                DateTime bornIn = DateFormat("dd-MM-yyyy", 'pt')
                    .parseStrict(dateStr.replaceAll('/', '-'));

                if (bornIn.compareTo(DateTime.now()) > 0 ||
                    bornIn.compareTo(DateTime(1900)) < 0) {
                  return 'Por favor introduza uma data válida';
                }

                DateTime allowedAge = DateTime(
                  bornIn.year + 16,
                  bornIn.month,
                  bornIn.day,
                );

                if (DateTime.now().isBefore(allowedAge)) {
                  return 'Tem de ter pelo menos 16 anos para criar conta';
                }
              } on Exception {
                return 'Por favor introduza uma data válida';
              }
              return null;
            },
            onSaved: (value) => birthdateC = value!,
            keyboardType: TextInputType.datetime,
          ),

          const SizedBox(height: 10),

          //Street
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Endereço',
                icon: Icon(Icons.house_rounded),
                hintText: "Nome da Rua e Número"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor introduza o seu endereço';
              }
              return null;
            },
            onSaved: (value) => streetC = value!,
          ),

          const SizedBox(height: 10),

          Row(children: [
            Expanded(
              child:
                  // PostCode
                  TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Código Postal',
                  icon: Icon(Icons.location_on_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Em falta';
                  }
                  // Do a sanity check on postcode
                  if (!RegExp(r"^[a-z0-9][a-z0-9\- ]{0,10}[a-z0-9]$",
                          caseSensitive: false)
                      .hasMatch(value)) {
                    return 'Inválido';
                  }
                  return null;
                },
                onSaved: (value) => postCodeC = value!,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child:
                  //City
                  TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  icon: Icon(Icons.location_city_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Em falta';
                  }
                  return null;
                },
                onSaved: (value) => cityC = value!,
              ),
            ),
          ]),

          const SizedBox(height: 20),

          // Country
          Row(children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(172, 28, 100, 120)),
                onPressed: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: false,
                    showWorldWide: false,
                    onSelect: (Country country) {
                      countryC = country.displayName.split(" ").first;
                      _countryController.text = countryC;
                    },
                    countryListTheme: const CountryListThemeData(
                      inputDecoration: InputDecoration(
                        labelText: 'Pesquisar',
                        hintText: 'Pesquise por o seu país',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                    ),
                  );
                },
                child: const Text('Selecionar País'),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'País',
                  icon: Icon(Icons.flag_rounded),
                ),
                controller: _countryController,
                validator: (value) {
                  if (value == null || value.isEmpty || value == "") {
                    return 'Em falta';
                  }
                  return null;
                },
              ),
            )
          ]),

          const SizedBox(height: 30),

          // Finish Registration Button
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  // 1) Save user information in database
                  APICaller()
                      .createClient(
                          email: email,
                          fname: fname,
                          lname: lname,
                          birthdate: birthdateC,
                          sex: sexC,
                          street: streetC,
                          postCode: postCodeC,
                          city: cityC,
                          country: countryC)
                      .then((result1) {
                    if (result1 != "ERROR" &&
                        json.decode(result1)["code"] == 0) {
                      // 2) Register Email/Password in Firebase Authentication
                      FirebaseAuthenticationCaller()
                          .signUp(email: email!, password: pass!)
                          .then((result2) {
                        if (result2 == null) {
                          APICaller()
                              .selectClient(email: email)
                              .then((userInfo) {
                            // Save data in Hive for caching
                            HiveHelper().addToBox(
                              UserProfile.fromJson(json.decode(userInfo)),
                              "UserProfile",
                              email,
                            );
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HealthInfoForm(
                                        emailP: email,
                                        fnameP: fname,
                                        lnameP: lname,
                                      )));
                        } else {
                          APICaller()
                              .deleteClient(email: email)
                              .then((return3) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Ocorreu um erro \nVerifique a sua conexão ou tente mais tarde",
                                style: TextStyle(fontSize: 16),
                              ),
                            ));
                          });
                        }
                      });
                    } else {
                      if (result1 == "ERROR") {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              ("Ocorreu um erro \nVerifique a sua conexão ou tente mais tarde"),
                              style: TextStyle(fontSize: 16)),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text((json.decode(result1)["msg"]),
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
                'Finalizar Registo',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
