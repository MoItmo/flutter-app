import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/failures.dart';

import '../../domian/entity/expense_entity.dart';
import '../../domian/repositories/expense_repository.dart';
import '../datasources/expense_remote_datasource.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remote;
  final FirebaseAuth auth;

  ExpenseRepositoryImpl(this.remote, this.auth);

  String? get _userId => auth.currentUser?.uid;

  @override
  Future<Either<Failure, List<ExpenseEntity>>> getExpenses() async {
    try {
      if (_userId == null) return left(AuthFailure("No logged in user"));
      final expenses = await remote.getExpenses(_userId!);
      return right(expenses);
    } catch (e) {
      return left(DatabaseFailure("Failed to load expenses: $e"));
    }
  }

  @override
  Future<Either<Failure, ExpenseEntity>> addExpense(ExpenseEntity expense) async {
    try {
      if (_userId == null) return left(AuthFailure("No logged in user"));
      final model = ExpenseModel(
        id: expense.id,
        title: expense.title,
        amount: expense.amount,
        date: expense.date,
        category: expense.category,
      );
      final result = await remote.addExpense(_userId!, model);
      return right(result);
    } catch (e) {
      return left(DatabaseFailure("Failed to add expense: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String id) async {
    try {
      if (_userId == null) return left(AuthFailure("No logged in user"));
      await remote.deleteExpense(_userId!, id);
      return right(null);
    } catch (e) {
      return left(DatabaseFailure("Failed to delete expense: $e"));
    }
  }
  @override
  Future<Either<Failure, ExpenseEntity>> updateExpense(ExpenseEntity expense) async {
    try {
      if (_userId == null) return left(AuthFailure("No logged in user"));

      final model = ExpenseModel(
        id: expense.id,
        title: expense.title,
        amount: expense.amount,
        date: expense.date,
        category: expense.category,
      );

      final result = await remote.updateExpense(_userId!, model);
      return right(result);
    } catch (e) {
      return left(DatabaseFailure("Failed to update expense: $e"));
    }
  }
}
