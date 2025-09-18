import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/expense_repository.dart';

class DeleteExpense {
  final ExpenseRepository repository;
  DeleteExpense(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteExpense(id);
  }
}
