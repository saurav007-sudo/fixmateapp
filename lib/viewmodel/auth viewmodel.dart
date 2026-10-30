import 'package:flutter/material.dart';

import '../repository/auth rep.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return false;
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _repository.signIn(email, password);
      _isLoading = false;
      notifyListeners();
      return user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return false;
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _repository.signUp(email, password);
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
      await _repository.sendPasswordReset(email);
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