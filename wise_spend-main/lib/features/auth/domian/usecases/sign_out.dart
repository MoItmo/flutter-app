
import 'package:dartz/dartz.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/usecase/no_params.dart';


class SignOut implements UseCase<void, NoParams> {
  final AuthRepository repo; SignOut(this.repo);
  @override
  Future<Either<Failure, void>> call(NoParams params) => repo.signOut();
}