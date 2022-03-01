// System Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthenticationCaller {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  // SIGN UP with email/password account
  Future<String?> signUp(
      {required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "network-request-failed") {
        return "A network error has occured \nPlease check your internet connection";
      } else if (e.code == "email-already-in-use") {
        return "An account already exists with this email";
      } else if (e.code == "invalid-email") {
        return "Invalid email \nPlease choose a valid one";
      } else if (e.code == 'weak-password') {
        return "Weak password \nPlease choose one with at least 6 characters";
      } else if (e.code == "operation-not-allowed") {
        return "Account registering is currently unavailable \nPlease try again later";
      } else {
        return "An error has occured. Please try again later";
      }
    }
  }

  // SIGN IN with email/password account
  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "network-request-failed") {
        return "A network error has occured \nPlease check your internet connection";
      } else if (e.code == "invalid-email" || e.code == "user-not-found") {
        return "This account does not exist";
      } else if (e.code == "wrong-password") {
        return "Incorrect password";
      } else if (e.code == "user-disabled") {
        return "This account is currently disabled \nPlease try again later";
      } else {
        return "An error has occured. Please try again later";
      }
    }
  }

  // SIGN UP/IN with gmail account
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      return "An error has occured. \nCheck your credentials and internet connection or try again later.";
    }
    return null;
  }

  // SIGN OUT
  Future<void> signOut() async => await _auth.signOut();
}
