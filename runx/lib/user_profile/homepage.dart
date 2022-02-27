// System Packages
import 'package:flutter/material.dart';

// Screens
import 'package:runx/auth_account/utils.dart';
import 'package:runx/auth_account/sign_in.dart';
import 'package:runx/user_profile/exercises.dart';
import 'package:runx/user_profile/people.dart';
import 'package:runx/user_profile/settings.dart';
import 'package:runx/presentation/icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('User Profile Main Page'),
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
