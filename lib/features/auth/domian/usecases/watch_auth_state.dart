import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/user_entity.dart';
import '../repositories/auth_repository.dart';


class WatchAuthState {
  final AuthRepository repo; WatchAuthState(this.repo);
  Stream<Either<Failure, UserEntity?>> call() => repo.watchAuthState();
}