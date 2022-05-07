import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationServices {
  final FirebaseAuth _firebaseAuth;

  AuthenticationServices(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign In Method
  Future<String?> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Sign In";
    } on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

  // Sign Up method
  Future<String?> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Sign Up";
    } on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

  // Sign Out method
  Future<String?> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return "Sign Out";
    } on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

  // Reset Password
  Future<String?> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "Reset Password";
    } on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

  // Get Current User
  User? getUser() {
    try {
      print(_firebaseAuth.currentUser?.uid);
      return _firebaseAuth.currentUser;
    } on FirebaseAuthException {

    }
  }

}