// System Packages
import 'package:flutter/material.dart';

// Logic
import 'package:runx/authentication/firebase.dart';

// Screens
import 'package:runx/authentication/sign_up.dart';
import 'package:runx/presentation/page_nav.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          const SizedBox(height: 20),
          Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 250,
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
                    // If result is null, the user is succesfully authenticated and will be redirected to home page
                    if (result == null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PageNav()));
                    }
                    // Else show error message
                    else {
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
