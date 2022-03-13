// System Packages
import 'dart:convert';
import 'package:flutter/material.dart';

// Logic
import 'package:runx/authentication/firebase.dart';
import 'package:runx/api.dart';

// Screens
import 'package:runx/authentication/info_form.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const SizedBox(height: 20),
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
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Text('      Já tem conta?  ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Entrar Aqui',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.blue)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
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
          // First Name
          TextFormField(
              decoration: InputDecoration(
                labelText: 'Primeiro Nome',
                prefixIcon: const Icon(Icons.account_circle),
                border: border,
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
            decoration: InputDecoration(
              labelText: 'Ultimo Nome',
              prefixIcon: const Icon(Icons.account_circle),
              border: border,
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
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                labelText: 'Email',
                border: border),
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
              prefixIcon: const Icon(Icons.lock_outline),
              border: border,
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
            decoration: InputDecoration(
              labelText: 'Confirmar Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: border,
            ),
            obscureText: true,
            validator: (value) {
              if (value != pass.text) {
                return 'Passwords não correspondem';
              }
              if (value == null || value.isEmpty) {
                return 'Por favor confirme a sua password';
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

                  // STEP 1) Save basic user information in database
                  APICaller()
                      .createClient(email: email, fname: fname, lname: lname)
                      .then((result1) {
                    // If result code is 0, the user information was successfully saved in our database
                    if (json.decode(result1)["code"] == 0) {
                      // STEP 2) Register Email/Password in Firebase Authentication
                      FirebaseAuthenticationCaller()
                          .signUp(email: email!, password: password!)
                          .then((result2) {
                        // If result is null, the user credentials were successfully saved in Firebase Authentication
                        if (result2 == null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InfoForm(
                                        emailP: email,
                                        fnameP: fname,
                                        lnameP: lname,
                                      )));
                        }
                        // Else the user credentials werent saved in Firebase Authentication,
                        // so the user previously created in the database is deleted, to maintain consistency
                        else {
                          APICaller()
                              .deleteClient(email: email)
                              .then((result3) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                result2,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ));
                          });
                        }
                      });
                    }
                    // Else, the user information wasn't saved in our database, show error message
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          json.decode(result1)["code"],
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
                'Registar',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
