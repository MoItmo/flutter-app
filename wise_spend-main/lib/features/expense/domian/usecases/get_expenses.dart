import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/expense_entity.dart';
import '../repositories/expense_repository.dart';

class GetExpenses {
  final ExpenseRepository repository;
  GetExpenses(this.repository);

  Future<Either<Failure, List<ExpenseEntity>>> call() {
    return repository.getExpenses();
  }
}
