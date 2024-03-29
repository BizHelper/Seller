import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth;
  Auth({required this.auth});

  Future<String?> signin(String _email, String _password) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      return "Success";
    } on FirebaseAuthException catch (error) {
      if (error.message == 'Given String is empty or null') {
        return 'The password is invalid';
      } else {
        return error.message;
      }
    }
  }

  Future<String?> signup(String _email, String _password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(
          email: _email, password: _password);
      return "Success";
    } on FirebaseAuthException catch (error) {
      if (error.message == 'Given String is empty or null') {
        return 'The password is invalid';
      } else {
        return error.message;
      }
    }
  }
}