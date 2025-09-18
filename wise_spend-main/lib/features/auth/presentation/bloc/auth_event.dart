part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// Should be dispatched once (e.g. when app starts) to begin listening to auth changes.
class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// Internal event: emitted when domain stream reports a user (or null).
class AuthUserChanged extends AuthEvent {
  final UserEntity? user;
  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

/// Trigger sign-in flow (Email/Password)
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthSignInRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

/// Trigger sign-out
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// Internal: convert domain failure -> state
class AuthErrorOccurred extends AuthEvent {
  final String message;
  const AuthErrorOccurred(this.message);

  @override
  List<Object?> get props => [message];
}
