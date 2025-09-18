import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/register_entity.dart';
import '../entity/user_entity.dart';


abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmail({required String email, required String password});
  Future<Either<Failure, void>> signOut();
  Stream<Either<Failure, UserEntity?>> watchAuthState();
  Future<Either<Failure, RegisterEntity>> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  });
}