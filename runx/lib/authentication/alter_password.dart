// System Packages
import 'package:flutter/material.dart';

// Logic
import 'package:runx/authentication/logic/firebase_services.dart';

// Screens
import 'package:runx/authentication/login.dart';

class AlterPassword extends StatelessWidget {
  const AlterPassword({Key? key}) : super(key: key);

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
                'Introduza o seu email',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Flexible(
                child: Text(
                  "Receba na sua caixa de correio um email com um link onde poderá alterar a sua password",
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
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
              const Text(
                'Sabe a sua password?  ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                child: const Text('Entrar',
                    style: TextStyle(fontSize: 18, color: Colors.blue)),
              )
            ],
          ),
          const SizedBox(height: 40),
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

          const SizedBox(height: 30),

          // Submit Form Button
          SizedBox(
            height: 50,
            width: 184,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  FirebaseAuthenticationCaller()
                      .resetPassword(email!)
                      .then((value) {
                    if (value != "ERROR") {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "Email de reset enviado!",
                          style: TextStyle(fontSize: 16),
                        ),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "Ocorreu um erro.\nVerifique o email introduzido e a sua conexão ou tente mais tarde",
                          style: TextStyle(fontSize: 16),
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
                'Alterar',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
