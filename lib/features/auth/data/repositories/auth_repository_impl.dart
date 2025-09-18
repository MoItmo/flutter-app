import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';

import '../../domian/entity/register_entity.dart';
import '../../domian/entity/user_entity.dart';
import '../../domian/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(this.remote, this.networkInfo);

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remote.signInWithEmail(email, password);
      return right(UserModel.fromFirebaseUser(user));
    } on Exception catch (e) {
      return left(AuthFailure('Sign-in failed', c: e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remote.signOut();
      return right(null);
    } on Exception catch (e) {
      return left(AuthFailure('Sign-out failed', c: e));
    }
  }

  @override
  Stream<Either<Failure, UserEntity?>> watchAuthState() async* {
    try {
      await for (final user in remote.authStateChanges()) {
        yield right(user == null ? null : UserModel.fromFirebaseUser(user));
      }
    } on Exception catch (e) {
      yield left(AuthFailure('Auth state stream error', c: e));
    }
  }
  @override
  Future<Either<Failure, RegisterEntity>> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return left(AuthFailure('No network connection'));
      }

      final registerModel = await remote.registerWithEmail(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
      );

      // registerModel extends RegisterEntity so we can return it directly as the entity
      return right(registerModel);
    } on Exception catch (e) {
      return left(AuthFailure('Registration failed', c: e));
    }
  }
}
