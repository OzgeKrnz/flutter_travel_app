import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/auth/screen/login_screen.dart';
import 'package:travel_app/shared/glass_info_tile.dart';
import 'package:travel_app/shared/glass_logout_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) { setState(() => _userData = {}); return; }
    final snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    setState(() => _userData = snap.data() ?? {});
  }

  String _fmtTs(dynamic ts) {
    if (ts == null) return '-';
    try {
      final d = (ts as Timestamp).toDate();
      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    } catch (_) { return ts.toString(); }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final fullName = (_userData?['fullName'] as String?) ?? (user?.displayName ?? '-');
    final createdAt = _fmtTs(_userData?['createdAt']);
    final lastLogin = _fmtTs(_userData?['lastLogin']);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              GlassInfoTile(
                icon: Icons.person,
                title: 'Ad Soyad',
                value: fullName,
              ),
              const SizedBox(height: 12),
              GlassInfoTile(
                icon: Icons.event_available_rounded,
                title: 'Hesap Oluşturma',
                value: createdAt,
              ),
              const SizedBox(height: 12),
              GlassInfoTile(
                icon: Icons.schedule_rounded,
                title: 'Son Giriş',
                value: lastLogin,
              ),
              const SizedBox(height: 24),
              GlassLogoutButton(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
