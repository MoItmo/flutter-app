import 'package:dartz/dartz.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entity/user_entity.dart';
import '../repositories/auth_repository.dart';


class SignInWithEmail implements UseCase<UserEntity, Params> {
  final AuthRepository repo; SignInWithEmail(this.repo);
  @override
  Future<Either<Failure, UserEntity>> call(Params p) => repo.signInWithEmail(email: p.email, password: p.password);
}


class Params {
  final String email; final String password;
  const Params(this.email, this.password);
}