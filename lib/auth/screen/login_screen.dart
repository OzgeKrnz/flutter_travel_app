import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/auth/services/auth_service.dart';
import 'package:travel_app/auth/screen/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(AuthService());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ValueListenableBuilder<bool>(
          valueListenable: _controller.isLoading,
          builder: (_, loading, __) {
            if (loading) return const CircularProgressIndicator();
            return ElevatedButton.icon(
              onPressed: () async {
                try {
                  final cred = await _controller.signInWithGoogle();
                  final user = cred?.user;
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        user != null
                            ? 'Hoş geldin ${user.displayName}'
                            : 'İptal edildi',
                      ),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  final msg = _controller.error.value ?? 'Giriş başarısız';
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(msg)));
                }
              },
              icon: const Icon(Icons.login),
              label: const Text('Google ile giriş'),
            );
          },
        ),
      ),
    );
  }
}
