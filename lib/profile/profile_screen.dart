import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/auth/screen/login_screen.dart';
import 'package:travel_app/shared/glass_info_tile.dart';
import 'package:travel_app/shared/glass_logout_button.dart';
import 'package:travel_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';




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

  String _fmtTs(dynamic ts, BuildContext ctx) {
    if (ts == null) return '-';
    try {
      final d = (ts as Timestamp).toDate();
      final localeTag = Localizations.localeOf(ctx).toLanguageTag(); 
      return DateFormat.yMMMd(localeTag).format(d);
    } catch (_) {
      return ts.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final user = FirebaseAuth.instance.currentUser;
    final fullName = (_userData?['fullName'] as String?) ?? (user?.displayName ?? '-');
    final createdAt = _fmtTs(_userData?['createdAt'], context);
    final lastLogin  = _fmtTs(_userData?['lastLogin'], context);

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
                title: loc.profile_full_name,
                value: fullName,
              ),
              const SizedBox(height: 12),
              GlassInfoTile( 
                icon: Icons.event_available_rounded,
                title: loc.profile_created_at,
                value: createdAt,
              ),
              const SizedBox(height: 12),
              GlassInfoTile(
                icon: Icons.schedule_rounded,
                title: loc.profile_last_login,
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
