import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<List<ExpenseModel>> getExpenses(String userId);
  Future<ExpenseModel> addExpense(String userId, ExpenseModel expense);
  Future<void> deleteExpense(String userId, String expenseId);
  Future<ExpenseModel> updateExpense(String userId, ExpenseModel expense);

}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final FirebaseFirestore firestore;

  ExpenseRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<ExpenseModel>> getExpenses(String userId) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ExpenseModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<ExpenseModel> addExpense(String userId, ExpenseModel expense) async {
    final docRef = firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc();

    final model = expense.copyWith(id: docRef.id);
    await docRef.set(model.toJson());
    return model;
  }

  @override
  Future<void> deleteExpense(String userId, String expenseId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expenseId)
        .delete();
  }

  @override
  Future<ExpenseModel> updateExpense(String userId, ExpenseModel expense) async {
    final docRef = firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expense.id);

    await docRef.update(expense.toJson());
    return expense;
  }
}
