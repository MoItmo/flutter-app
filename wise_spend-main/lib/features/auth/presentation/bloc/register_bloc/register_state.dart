part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterEntity user;

  const RegisterSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class RegisterFailure extends RegisterState {
  final String message;

  const RegisterFailure(this.message);

  @override
  List<Object?> get props => [message];
}
