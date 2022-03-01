// System Packages
import 'dart:convert';
import 'package:flutter/material.dart';

// Screens
import 'package:runx/authentication/firebase.dart';
import 'package:runx/api.dart';
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
                'Create your account here!',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SignupForm(),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Text('      Already Registered?  ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Sign In Here',
                          style: TextStyle(fontSize: 20, color: Colors.blue)),
                    )
                  ],
                )
              ],
            ),
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
                labelText: 'First Name',
                prefixIcon: const Icon(Icons.account_circle),
                border: border,
              ),
              onSaved: (val) {
                fname = val;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Your First Name';
                }
                return null;
              },
              keyboardType: TextInputType.name),
          space,

          // Last Name
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Last Name',
              prefixIcon: const Icon(Icons.account_circle),
              border: border,
            ),
            onSaved: (val) {
              lname = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Enter Your Last Name';
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
              if (value!.isEmpty) {
                return 'Please Enter Your Email';
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
              if (value!.isEmpty) {
                return 'Please Enter Your Password';
              }
              return null;
            },
          ),
          space,

          // Confirm Password
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: border,
            ),
            obscureText: true,
            validator: (value) {
              if (value != pass.text) {
                return 'Password Does Not Match';
              }
              if (value!.isEmpty) {
                return 'Please Confirm Your Password';
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

                  // 1) Save basic user information in database
                  APICaller()
                      .createUser(email: email, fname: fname, lname: lname)
                      .then((result1) {
                    print(result1);
                    if (json.decode(result1)["code"] == 0) {
                      // 2) Register Email/Password in Firebase Authentication
                      FirebaseAuthenticationCaller()
                          .signUp(email: email!, password: password!)
                          .then((result2) {
                        if (result2 == null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InfoForm(
                                        emailP: email,
                                        fnameP: fname,
                                        lnameP: lname,
                                      )));
                        } else {
                          APICaller().deleteUser(email: email).then((return3) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "An error has occured\nCheck your connetion or try again later",
                                style: TextStyle(fontSize: 16),
                              ),
                            ));
                          });
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          json.decode(result1)["code"],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ));
                    }
                  });
                  /*
                  // 2) Register Email/Password in Firebase Authentication
                  FirebaseAuthenticationHelper()
                      .signUp(email: email!, password: password!)
                      .then((result) {
                    if (result == null) {
                      // 2) Call API and register user data in database
                      APICaller()
                          .createUser(email: email, fname: fname, lname: lname)
                          .then((result) {
                        print(email! + "\n " + fname! + "\n " + lname!);
                        print(result);
                      });

                      // 3) Go to aditional info form
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfoForm(
                                    emailP: email,
                                    fnameP: fname,
                                    lnameP: lname,
                                  )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          result,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ));
                    }
                  });
                  */
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
