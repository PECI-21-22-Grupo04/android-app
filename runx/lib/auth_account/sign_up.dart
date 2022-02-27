// System Packages
import 'package:flutter/material.dart';

// Screens
import 'package:runx/auth_account/utils.dart';
import 'package:runx/user_profile/homepage.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const SizedBox(height: 80),
          // logo
          Column(
            children: const [
              FlutterLogo(
                size: 55,
              ),
              SizedBox(height: 50),
              Text(
                'Create Your New Account Here!',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: SignupForm(),
          ),

          const SizedBox(height: 30),

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

  Container buildLogo() {
    return Container(
      height: 80,
      width: 80,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.blue),
      child: const Center(
        child: Text(
          "T",
          style: TextStyle(color: Colors.white, fontSize: 60.0),
        ),
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

  String? email;
  String? password;
  String? Fname;
  String? Lname;
  bool _obscureText = false;

  bool agree = false;

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
              Fname = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Enter Your First Name';
              }
              return null;
            },
          ),
          space,
          // Last Name
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Last Name',
              prefixIcon: const Icon(Icons.account_circle),
              border: border,
            ),
            onSaved: (val) {
              Lname = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Enter Your Last Name';
              }
              return null;
            },
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

                  AuthenticationHelper()
                      .signUp(email: email!, password: password!)
                      .then((result) {
                    if (result == null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
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
