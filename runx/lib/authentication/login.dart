// System Packages
import 'dart:convert';
import 'package:flutter/material.dart';

// Models
import 'package:runx/caching/models/instructor_profile.dart';
import 'package:runx/caching/models/user_profile.dart';

// Logic
import 'package:runx/authentication/logic/firebase_services.dart';
import 'package:runx/api.dart';
import 'package:runx/caching/hive_helper.dart';

// Screens
import 'package:runx/presentation/bottom_nav.dart';
import 'package:runx/authentication/sign_up.dart';
import 'package:runx/authentication/alter_password.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          const SizedBox(height: 50),
          Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Bem vindo de volta!',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: LoginForm(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 15),
              const Text('Não tem conta?  ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Signup()));
                },
                child: const Text('Registar',
                    style: TextStyle(fontSize: 18, color: Colors.blue)),
              )
            ],
          ),
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Esqueceu a password? ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AlterPassword()));
                },
                child: const Text('Alterar',
                    style: TextStyle(fontSize: 18, color: Colors.blue)),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // Email
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Email', icon: Icon(Icons.email_outlined)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor introduza o seu email';
              }
              return null;
            },
            onSaved: (val) {
              email = val;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 20,
          ),

          // Password
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              icon: const Icon(Icons.lock_outline),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            obscureText: _obscureText,
            onSaved: (val) {
              password = val;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor introduza a sua password';
              }
              return null;
            },
          ),

          const SizedBox(height: 30),

          // Submit Form Button
          SizedBox(
            height: 50,
            width: 184,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Call Firebase to authenticate user
                  FirebaseAuthenticationCaller()
                      .signIn(email: email!, password: password!)
                      .then((result) {
                    if (result == null) {
                      APICaller().selectClient(email: email).then(
                        (userInfo) {
                          if (userInfo != "ERROR" &&
                              json.decode(userInfo)["code"] == 0) {
                            // Save data in Hive or update if it already exists
                            HiveHelper()
                                .addToBox(
                                    UserProfile.fromJson(json.decode(userInfo)),
                                    "UserProfile",
                                    email)
                                .then((value1) {
                              APICaller()
                                  .isClientAssociated(email: email)
                                  .then((isAssociated) {
                                if (isAssociated != "ERROR" &&
                                    json.decode(isAssociated)["code"] != 1) {
                                  APICaller()
                                      .selectAssociatedInstructor(email: email)
                                      .then(
                                    (instr) async {
                                      if (instr != "ERROR" &&
                                          json.decode(instr)["code"] == 0 &&
                                          json.decode(instr)["data"] != null) {
                                        // 2º - Convert json received to objects
                                        List<InstructorProfile> itemsList =
                                            List<InstructorProfile>.from(
                                          json.decode(instr)["data"][0].map(
                                                (i) =>
                                                    InstructorProfile.fromJson(
                                                        i),
                                              ),
                                        );
                                        // 3º - Remove old cached items
                                        for (InstructorProfile cachedIp
                                            in await HiveHelper()
                                                .getAll("InstructorProfile")) {
                                          if (!itemsList
                                              .map((item) => item.email)
                                              .contains(cachedIp.email)) {
                                            HiveHelper().removeFromBox(
                                                "InstructorProfile",
                                                cachedIp.email);
                                          }
                                        }
                                        // 4º Cache the new database items
                                        for (InstructorProfile ip
                                            in List.from(itemsList)) {
                                          HiveHelper().addToBox(ip,
                                              "InstructorProfile", ip.email);
                                        }
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const BottomNav(),
                                          ),
                                        );
                                      } else if (instr != "ERROR" &&
                                          json.decode(instr)["code"] == 2) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const BottomNav(),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Ocorreu um problema. Verifique a sua conexão ou tente mais tarde.",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Ocorreu um problema. Verifique a sua conexão ou tente mais tarde.",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  );
                                }
                              });
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Ocorreu um problema. Verifique a sua conexão ou tente mais tarde.",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          result,
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
                'Entrar',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
