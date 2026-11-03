import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth ser.dart';

class AuthRepository {
  final AuthServices _services = AuthServices();

  Future<User?> signIn(String email, String password) async {
    return await _services.signInWithEmail(email, password);
  }

  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String dob,
  }) async {
    return await _services.signUpWithEmail(
      email: email,
      password: password,
      name: name,
      phone: phone,
      dob: dob,
    );
  }

  Future<void> sendPasswordReset(String email) async {
    await _services.sendPasswordResetEmail(email);
  }

  Future<User?> signInWithGoogle() async {
    return await _services.signInWithGoogle();
  }
}