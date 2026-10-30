import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth ser.dart';

class AuthRepository {
  final AuthServices _services = AuthServices();

  Future<User?> signIn(String email, String password) async {
    return await _services.signInWithEmail(email, password);
  }

  Future<User?> signUp(String email, String password) async {
    return await _services.signUpWithEmail(email, password);
  }

  Future<void> sendPasswordReset(String email) async {
    await _services.sendPasswordResetEmail(email);
  }

  Future<User?> signInWithGoogle() async {
    return await _services.signInWithGoogle();
  }
}