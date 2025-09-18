import 'package:equatable/equatable.dart';
import '../../domian/entity/expense_entity.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class GetExpensesEvent extends ExpenseEvent {}

class AddExpenseEvent extends ExpenseEvent {
  final ExpenseEntity expense;
  const AddExpenseEvent(this.expense);

  @override
  List<Object?> get props => [expense];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String id;
  const DeleteExpenseEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateExpenseEvent extends ExpenseEvent {
  final ExpenseEntity expense;
  const UpdateExpenseEvent(this.expense);

  @override
  List<Object?> get props => [expense];
}
