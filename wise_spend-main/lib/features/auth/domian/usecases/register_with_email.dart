import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/register_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterWithEmail implements UseCase<RegisterEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterWithEmail(this.repository);

  @override
  Future<Either<Failure, RegisterEntity>> call(RegisterParams params) {
    return repository.registerWithEmail(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
      phone: params.phone,
    );
  }
}

class RegisterParams {
  final String fullName;
  final String email;
  final String password;
  final String? phone;

  RegisterParams({
    required this.fullName,
    required this.email,
    required this.password,
    this.phone,
  });
}
