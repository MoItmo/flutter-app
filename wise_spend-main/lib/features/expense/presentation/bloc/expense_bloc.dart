import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domian/usecases/add_expense.dart';
import '../../domian/usecases/delete_expense.dart';
import '../../domian/usecases/get_expenses.dart';
import '../../domian/usecases/update_usecase.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetExpenses getExpenses;
  final AddExpense addExpense;
  final DeleteExpense deleteExpense;
  final UpdateExpense updateExpense;

  ExpenseBloc({
    required this.getExpenses,
    required this.addExpense,
    required this.deleteExpense,
    required this.updateExpense,
  }) : super(ExpenseInitial()) {
    on<GetExpensesEvent>(_onGetExpenses);
    on<AddExpenseEvent>(_onAddExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
  }

  Future<void> _onGetExpenses(
      GetExpensesEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    final result = await getExpenses();
    result.fold(
          (failure) => emit(ExpenseError(failure.message)),
          (expenses) => emit(ExpenseLoaded(expenses)),
    );
  }
  Future<void> _onAddExpense(
      AddExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());

    final result = await addExpense(event.expense);

    if (result.isLeft()) {
      result.fold((failure) => emit(ExpenseError(failure.message)), (_) {});
    } else {
      final refreshed = await getExpenses();
      refreshed.fold(
            (failure) => emit(ExpenseError(failure.message)),
            (expenses) => emit(ExpenseLoaded(expenses)),
      );
    }
  }

  Future<void> _onDeleteExpense(
      DeleteExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());

    final result = await deleteExpense(event.id);

    if (result.isLeft()) {
      result.fold((failure) => emit(ExpenseError(failure.message)), (_) {});
    } else {
      final refreshed = await getExpenses();
      refreshed.fold(
            (failure) => emit(ExpenseError(failure.message)),
            (expenses) => emit(ExpenseLoaded(expenses)),
      );
    }
  }

  Future<void> _onUpdateExpense(
      UpdateExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());

    final result = await updateExpense(event.expense);

    if (result.isLeft()) {
      result.fold((failure) => emit(ExpenseError(failure.message)), (_) {});
    } else {
      final refreshed = await getExpenses();
      refreshed.fold(
            (failure) => emit(ExpenseError(failure.message)),
            (expenses) => emit(ExpenseLoaded(expenses)),
      );
    }
  }

}
