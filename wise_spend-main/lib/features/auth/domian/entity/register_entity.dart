import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String uid;
  final String? fullName;
  final String? email;
  final String? phone;


  const RegisterEntity({
    required this.uid,
    this.fullName,
    this.email,
    this.phone,
  });


  @override
  List<Object?> get props => [uid, fullName, email, phone];
}