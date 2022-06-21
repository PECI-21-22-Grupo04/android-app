// System Packages
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';

// Models
import 'package:runx/caching/models/user_profile.dart';

// Logic
import 'package:runx/api.dart';
import 'package:runx/caching/hive_helper.dart';
import 'package:runx/profile/logic/upload_pic.dart';

// Widgets
import 'package:runx/profile/widgets/profilewidget.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil'),
        toolbarHeight: 55,
        leading: Builder(builder: (context) => const BackButton()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const SizedBox(height: 10),
          ProfileWidget(
            imagePath: 'assets/images/profile_icon.png',
            isEdit: true,
            onClicked: () async {
              uploadPic();
            },
          ),
          const SizedBox(height: 15),
          Column(
            children: const [
              Text('Informações Pessoais',
                  style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SignupForm(),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

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

  get heightC => null;

  @override
  Widget build(BuildContext context) {
    Box userInfo = Hive.box("UserProfile");
    TextEditingController _countryController = TextEditingController();
    _countryController.text = countryC;
    sexC = userInfo.get(FirebaseAuth.instance.currentUser!.email).getSex();
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // Sex
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: userInfo
                  .get(FirebaseAuth.instance.currentUser!.email)
                  .getSex(),
              icon: const Icon(Icons.account_circle_rounded),
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
            initialValue: userInfo
                .get(FirebaseAuth.instance.currentUser!.email)
                .getBirthdate(),
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
            initialValue: userInfo
                .get(FirebaseAuth.instance.currentUser!.email)
                .getStreet(),
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
                initialValue: userInfo
                    .get(FirebaseAuth.instance.currentUser!.email)
                    .getPostCode(),
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
                initialValue: userInfo
                    .get(FirebaseAuth.instance.currentUser!.email)
                    .getCity(),
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

                  APICaller()
                      .updateClient(
                          email: FirebaseAuth.instance.currentUser!.email,
                          fname: userInfo
                              .get(FirebaseAuth.instance.currentUser!.email)
                              .getFirstName(),
                          lname: userInfo
                              .get(FirebaseAuth.instance.currentUser!.email)
                              .getLastName(),
                          birthdate: birthdateC,
                          sex: sexC.toString(),
                          street: streetC,
                          postCode: postCodeC,
                          city: cityC,
                          country: countryC)
                      .then((clientUpdated) {
                    if (clientUpdated != "ERROR" &&
                        json.decode(clientUpdated)["code"] == 0) {
                      APICaller()
                          .selectClient(
                              email: FirebaseAuth.instance.currentUser!.email)
                          .then(
                        (userInfo) {
                          if (userInfo != "ERROR" &&
                              json.decode(userInfo)["code"] == 0) {
                            // Save data in Hive or update if it already exists
                            HiveHelper().addToBox(
                                UserProfile.fromJson(json.decode(userInfo)),
                                "UserProfile",
                                FirebaseAuth.instance.currentUser!.email);
                          }
                        },
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            ("Os seus dados foram atualizados com sucesso!"),
                            style: TextStyle(fontSize: 16)),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            ("Ocorreu um erro \nVerifique a sua conexão ou tente mais tarde"),
                            style: TextStyle(fontSize: 16)),
                      ));
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 8, 162, 54),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
              child: const Text(
                'Atualizar Dados',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 50,
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 209, 39, 39),
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
