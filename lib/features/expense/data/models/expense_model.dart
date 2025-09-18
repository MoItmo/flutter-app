import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domian/entity/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.date,
    required super.category,
  });

  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: doc.id,
      title: data['title'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      category: data['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'amount': amount,
    'date': date,
    'category': category,
  };

  ExpenseModel copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    String? category,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }
}
