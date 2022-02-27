import 'package:flutter/material.dart';
import 'package:runx/email_example/firebase.dart';
import 'package:runx/email_example/login.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Welcome'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AuthenticationHelper()
              .signOut()
              .then((_) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (contex) => const Login()),
                  ));
        },
        child: const Icon(Icons.logout),
        tooltip: 'Logout',
      ),
    );
  }
}
