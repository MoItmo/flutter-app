import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/expense_entity.dart';
import '../repositories/expense_repository.dart';

class UpdateExpense {
  final ExpenseRepository repository;

  UpdateExpense(this.repository);

  Future<Either<Failure, ExpenseEntity>> call(ExpenseEntity expense) {
    return repository.updateExpense(expense);
  }
}
