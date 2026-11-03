import 'package:flutter/material.dart';
import '../repository/auth rep.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String dob,
  }) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty || dob.isEmpty) {
      return "Please fill in all fields.";
    }

    _isLoading = true;
    notifyListeners();

    try {
      final user = await _repository.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
        dob: dob,
      );
      _isLoading = false;
      notifyListeners();

      if (user != null) {
        return null; // Success
      } else {
        return "Registration failed. Please try again.";
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      String errorMessage = "Registration failed.";
      String errorStr = e.toString().toLowerCase();

      if (errorStr.contains("email-already-in-use")) {
        errorMessage = "This email is already registered. Try logging in.";
      } else if (errorStr.contains("weak-password")) {
        errorMessage = "Password is too weak. Please use at least 6 characters.";
      } else if (errorStr.contains("invalid-email")) {
        errorMessage = "The email address is badly formatted.";
      } else {
        errorMessage = e.toString();
      }

      return errorMessage;
    }
  }

  Future<bool> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return false;
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _repository.signIn(email.trim(), password.trim());
      _isLoading = false;
      notifyListeners();
      return user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    if (email.isEmpty || !email.contains('@')) return false;
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.sendPasswordReset(email.trim());
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _repository.signInWithGoogle();
      _isLoading = false;
      notifyListeners();
      return user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}