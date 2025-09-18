import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domian/entity/expense_entity.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/category_expenses_card.dart';
import '../widgets/expense_category_card.dart';
import 'add_expense_page.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  void initState() {
    super.initState();
    // Kick off load
    context.read<ExpenseBloc>().add(GetExpensesEvent());
  }

  void _signOut(BuildContext context) {
    context.read<AuthBloc>().add(const AuthSignOutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'My expenses',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 26,
            shadows: [Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black12)],
          ),
        ),
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          )

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_left)),
                const Text('September', style: TextStyle(color: Colors.purple)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right)),
              ],
            ),
            const SizedBox(height: 12),

            Expanded(
              child: BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  if (state is ExpenseLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ExpenseLoaded) {
                    final expenses = state.expenses;
                    if (expenses.isEmpty) {
                      return const Center(child: Text('No expenses yet'));
                    }

                    Map<String, double> categoryTotals = {};
                    for (var e in expenses) {
                      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
                    }

                    return ListView.builder(
                      itemCount: categoryTotals.length,
                      padding: const EdgeInsets.only(bottom: 24),
                      itemBuilder: (context, index) {
                        final category = categoryTotals.keys.elementAt(index);
                        final total = categoryTotals[category] ?? 0;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CategoryExpensesPage(
                                    category: category,
                                    expenses: expenses.where((e) => e.category == category).toList(),
                                  ),
                                ),
                              );
                            },
                            child: ExpenseCategoryCard(category: category, total: total),
                          ),
                        );
                      },
                    );
                  } else if (state is ExpenseError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.92,
          height: 52, // pill height
          child: Material(
            // elevation for shadow
            elevation: 8,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const AddExpensePage(),
                );
                context.read<ExpenseBloc>().add(GetExpensesEvent());
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4F46E5),
                      Color(0xFF7C3AED),
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
                    // small icon box on the left
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Add new expense',
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

class ExpenseCard extends StatelessWidget {
  final ExpenseEntity entity;
  final VoidCallback? onDelete;

  ExpenseCard({super.key, required this.entity, this.onDelete});
  Map<String, String> categoryAssets = {
    'Essentials': 'assets/images/Essentials.png',
    'Miscellaneous': 'assets/images/Miscellaneous.png',
    'Personal': 'assets/images/Personal.png',
  };
  @override
  Widget build(BuildContext context) {
    print('++++++++++');
    print(entity.category);
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF7C3AED)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 6))],
      ),
      height: MediaQuery.sizeOf(context).height*0.2,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(entity.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(entity.category, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                    child: Text('${entity.amount.toString()} \$', style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(right: 12.0),
            child: SizedBox(
              width: 110,
              height: 110,
              child: ClipRRect(
                borderRadius:  BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
                child: OverflowBox(
                  maxWidth: 160,
                  maxHeight: 160,
                  //categoryAssets
                  child: Image.asset(categoryAssets[entity.category] ?? 'assets/images/essentials.png', fit: BoxFit.contain, errorBuilder: (c, e, s) => const SizedBox.shrink()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
