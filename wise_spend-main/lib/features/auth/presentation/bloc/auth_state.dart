part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final UserEntity? user;
  final String? error;

  const AuthState._({this.isLoading = false, this.user, this.error});

  const AuthState.unknown() : this._();
  const AuthState.loading() : this._(isLoading: true);
  const AuthState.authenticated(UserEntity u) : this._(user: u);
  const AuthState.unauthenticated() : this._(user: null);
  const AuthState.failure(String message) : this._(error: message);

  @override
  List<Object?> get props => [isLoading, user, error];

  @override
  String toString() =>
      'AuthState { isLoading: $isLoading, user: ${user?.uid}, error: $error }';
}
