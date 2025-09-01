import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:travel_app/auth/services/auth_service.dart';

//Login Controller

class LoginController {

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> error = ValueNotifier(null);

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final cred = await AuthService.signInWithGoogle();
      return cred;
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() => AuthService.signOut();

  User? get currentUser => AuthService.getCurrentUser();

  void dispose() {
    isLoading.dispose();
    error.dispose();
  }
}
