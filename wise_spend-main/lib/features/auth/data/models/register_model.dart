
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:meta/meta.dart';

import '../../domian/entity/register_entity.dart';


@immutable
class RegisterModel extends RegisterEntity {
  const RegisterModel({
    required String uid,
    String? fullName,
    String? email,
    String? phone,
  }) : super(uid: uid, fullName: fullName, email: email, phone: phone);

  /// Create a RegisterModel from a Firebase [fb.User]
  factory RegisterModel.fromFirebaseUser(fb.User user) {
    return RegisterModel(
      uid: user.uid,
      fullName: user.displayName,
      email: user.email,
      phone: user.phoneNumber,
    );
  }

  /// Map conversion (useful for Firestore / REST)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phone': phone,
    };
  }

  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      uid: map['uid'] as String,
      fullName: map['fullName'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
    );
  }

  /// JSON helpers
  String toJson() => json.encode(toMap());

  factory RegisterModel.fromJson(String source) =>
      RegisterModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// CopyWith for immutability convenience
  RegisterModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phone,
  }) {
    return RegisterModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  @override
  String toString() =>
      'RegisterModel(uid: $uid, fullName: $fullName, email: $email, phone: $phone)';
}
