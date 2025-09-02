import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String fullName;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  const User({
    required this.uid,
    required this.fullName,
    this.createdAt,
    this.lastLogin,
  });

  // firebase coredata
  factory User.fromDoc(String uid, DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return User(
      uid: uid,
      fullName: (data['fullName'] as String?) ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      lastLogin: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
