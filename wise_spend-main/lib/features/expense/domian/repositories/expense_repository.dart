import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/expense_entity.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, List<ExpenseEntity>>> getExpenses();
  Future<Either<Failure, ExpenseEntity>> addExpense(ExpenseEntity expense);
  Future<Either<Failure, void>> deleteExpense(String id);
  Future<Either<Failure, ExpenseEntity>> updateExpense(ExpenseEntity expense);

}
