import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/usecase/no_params.dart';
import '../../../../core/error/failures.dart';
import '../../domian/entity/user_entity.dart';
import '../../domian/usecases/sign_in_with_email.dart';
import '../../domian/usecases/sign_out.dart';
import '../../domian/usecases/watch_auth_state.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmail _signInWithEmail;
  final SignOut _signOut;
  final WatchAuthState _watchAuthState;

  StreamSubscription<Either<Failure, UserEntity?>>? _authSubscription;

  AuthBloc(
      this._signInWithEmail,
      this._signOut,
      this._watchAuthState,
      ) : super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthUserChanged>(_onUserChanged);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthErrorOccurred>(_onErrorOccurred);
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    await _authSubscription?.cancel();

    // Listen to domain-level auth state (Either<Failure, UserEntity?>)
    _authSubscription = _watchAuthState().listen((either) {
      either.fold(
            (failure) => add(AuthErrorOccurred(failure.message)),
            (user) => add(AuthUserChanged(user)),
      );
    });
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    final user = event.user;
    if (user == null) {
      emit(const AuthState.unauthenticated());
    } else {
      emit(AuthState.authenticated(user));
    }
  }

  Future<void> _onSignInRequested(
      AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    final Either<Failure, UserEntity> res =
    await _signInWithEmail(Params(event.email, event.password));

    res.fold(
          (failure) => emit(AuthState.failure(failure.message)),
          (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onSignOutRequested(
      AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    final Either<Failure, void> res = await _signOut(const NoParams());

    res.fold(
          (failure) => emit(AuthState.failure(failure.message)),
          (_) => emit(const AuthState.unauthenticated()),
    );
  }

  void _onErrorOccurred(AuthErrorOccurred event, Emitter<AuthState> emit) {
    emit(AuthState.failure(event.message));
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }
}
