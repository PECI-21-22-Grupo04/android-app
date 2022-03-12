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
        return "Ocorreu um erro de rede. \nPor favor verifique a sua conexão à Internet";
      } else if (e.code == "email-already-in-use") {
        return "Uma conta já existe com este email. \nPor favor escolha outro";
      } else if (e.code == "invalid-email") {
        return "Email inválido. \nPor favor escolha outro";
      } else if (e.code == 'weak-password') {
        return "Password fraca. \nPor favor escolha uma com pelo menos 6 caracteres";
      } else if (e.code == "operation-not-allowed") {
        return "Criação de novas contas atualmente indisponível. \nPor favor tente mais tarde";
      } else {
        return "Ocorreu um erro. Por favor tente mais tarde";
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
        return "Ocorreu um erro de rede. \nPor favor verifique a sua conexão à Internet";
      } else if (e.code == "invalid-email" || e.code == "user-not-found") {
        return "Esta conta não existe. \nPor favor faça o registo do email";
      } else if (e.code == "wrong-password") {
        return "Password incorreta";
      } else if (e.code == "user-disabled") {
        return "Esta conta está atualmente desativada. \nPor favor tente mais tarde";
      } else {
        return "Ocorreu um erro. Por favor tente mais tarde";
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
      return "Ocorreu um erro. \nVerifique as suas credenciais ou tente mais tarde";
    }
    return null;
  }

  // SIGN OUT
  Future<void> signOut() async => await _auth.signOut();
}
