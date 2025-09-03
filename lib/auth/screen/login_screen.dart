import 'package:flutter/material.dart';
import 'package:travel_app/auth/screen/login_controller.dart';
import 'package:travel_app/l10n/app_localizations.dart';

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
    _controller = LoginController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.login_title)),
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

                  final msg =
                      user?.displayName != null &&
                          user!.displayName!.trim().isNotEmpty
                      ? loc.login_welcome(user.displayName!)
                      : loc.login_welcome_generic;

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(msg)));
                } catch (e) {
                  if (!mounted) return;
                  final msg = _controller.error.value ?? loc.login_failed;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(msg)));
                }
              },
              icon: const Icon(Icons.login),
              label: Text(loc.login_signin_google),
            );
          },
        ),
      ),
    );
  }
}
