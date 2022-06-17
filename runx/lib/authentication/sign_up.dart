// System Packages
import 'dart:convert';
import 'package:flutter/material.dart';

// Logic
import 'package:runx/api.dart';
import 'package:runx/authentication/logic/firebase_services.dart';

// Screens
import 'package:runx/authentication/login.dart';
import 'package:runx/authentication/screens/legal_info.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const SizedBox(height: 40),
          Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 175,
              ),
              const SizedBox(height: 20),
              const Text(
                'Crie a sua conta aqui!',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SignupForm(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 15),
              const Text('Já tem conta?  ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: const Text('Autenticar',
                    style: TextStyle(fontSize: 18, color: Colors.blue)),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key, String? email, String? fname, String? lname})
      : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  String? fname;
  String? lname;
  bool _obscureText = false;

  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var space = const SizedBox(height: 10);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // First Name
          TextFormField(
              decoration: const InputDecoration(
                labelText: 'Primeiro Nome',
                icon: Icon(Icons.account_circle),
              ),
              onSaved: (val) {
                fname = val;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor introduza o seu primeiro nome';
                }
                return null;
              },
              keyboardType: TextInputType.name),
          space,

          // Last Name
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Ultimo Nome',
              icon: Icon(Icons.account_circle),
            ),
            onSaved: (val) {
              lname = val;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor introduza o seu ultimo nome';
              }
              return null;
            },
            keyboardType: TextInputType.name,
          ),

          space,

          // Email
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email_outlined),
            ),
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
          space,

          // Password
          TextFormField(
            controller: pass,
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
            onSaved: (val) {
              password = val;
            },
            obscureText: !_obscureText,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor introduza a sua password';
              }
              return null;
            },
          ),
          space,

          // Confirm Password
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Confirmar Password',
              icon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
            validator: (value) {
              if (value != pass.text) {
                return 'Passwords não correspondem';
              }
              if (value == null || value.isEmpty) {
                return 'Por favor confirme a sua password';
              }
              if (value.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      ("Password fraca \nPor favor escolha uma com pelo menos 6 caracteres"),
                      style: TextStyle(fontSize: 16)),
                ));
              }
              return null;
            },
          ),
          space,
          const SizedBox(height: 30),

          // Sign-Up Button
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  // STEP 1) Check if user exists in database
                  APICaller().selectClient(email: email).then((result1) {
                    if (result1 != "ERROR" &&
                        json.decode(result1)["code"] == 2) {
                      // STEP 2) Check if user exists in firebase
                      FirebaseAuthenticationCaller()
                          .doesUserExist(email: email!)
                          .then((result2) {
                        if (result2 == "False") {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LegalInfo(
                                        emailP: email,
                                        fnameP: fname,
                                        lnameP: lname,
                                        passwP: password,
                                      )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text((result2),
                                style: const TextStyle(fontSize: 16)),
                          ));
                        }
                      });
                    } else {
                      if (result1 == "ERROR") {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              ("Ocorreu um erro. Verifique a sua conexão ou tente mais tarde"),
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
                'Continuar',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
