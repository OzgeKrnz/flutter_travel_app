import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileController extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // kulanıcı bilgisini getir
  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _db.collection("users").doc(user.uid).get();
    return doc.data();
  }

  // last login güncellemesi
  Future<void> updateLastLogin() async {
    final user = _auth.currentUser;

    if (user != null) {
      await _db.collection("users").doc(user.uid).set({
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  // log out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
