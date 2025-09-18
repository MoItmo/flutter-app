part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterRequested extends RegisterEvent {
  final String fullName;
  final String email;
  final String password;
  final String? phone;

  const RegisterRequested({
    required this.fullName,
    required this.email,
    required this.password,
    this.phone,
  });

  @override
  List<Object?> get props => [fullName, email, password, phone];
}
