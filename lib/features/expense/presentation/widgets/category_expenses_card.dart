import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hammad/features/expense/presentation/pages/update_page.dart';
import '../../domian/entity/expense_entity.dart';
import '../bloc/expense_state.dart';
import '../pages/expense_page.dart';
import '../pages/insights_page.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';

class CategoryExpensesPage extends StatelessWidget {
  final String category;
  final List<ExpenseEntity> expenses;

  const CategoryExpensesPage({
    super.key,
    required this.category,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final e = expenses[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BlocListener<ExpenseBloc, ExpenseState>(
                    listener: (context, state) {
                      if (state is ExpenseLoaded) {
                        // Refresh list after update
                        context.read<ExpenseBloc>().add(GetExpensesEvent());
                        Navigator.of(context).pop(); // close sheet
                      }
                      if (state is ExpenseError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    child: UpdateExpensePage(expense: e),
                  ),
                );
              },
              child: ExpenseCard(entity: e),
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.92,
          height: 52,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InsightsPage(expenses: expenses),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4F46E5), // blue-purple start
                      Color(0xFF7C3AED), // violet end
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.auto_graph, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Where is my money going?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
