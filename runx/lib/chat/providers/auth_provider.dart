// System Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthProvider({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  String? getFirebaseUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }
}
