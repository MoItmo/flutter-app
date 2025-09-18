import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domian/entity/expense_entity.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';

class UpdateExpensePage extends StatefulWidget {
  final ExpenseEntity expense;

  const UpdateExpensePage({Key? key, required this.expense}) : super(key: key);

  @override
  State<UpdateExpensePage> createState() => _UpdateExpensePageState();
}

class _UpdateExpensePageState extends State<UpdateExpensePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;
  late String _selectedCategory;

  final List<String> _categories = ['Essentials', 'Personal', 'Miscellaneous'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _amountController =
        TextEditingController(text: widget.expense.amount.toString());
    _selectedDate = widget.expense.date;
    _selectedCategory = widget.expense.category;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseLoaded) {
          // Refresh list after update
          context.read<ExpenseBloc>().add(GetExpensesEvent());
          // Close the sheet
          Navigator.of(context).pop();
        }

        if (state is ExpenseError) {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollCtrl) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              controller: scrollCtrl,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Update Expense',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Expense name'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: 'Enter title',
                            ),
                            validator: (v) =>
                            (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),

                          const Text('Date'),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: _pickDate,
                            child: IgnorePointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  hintText: _selectedDate
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0],
                                  suffixIcon:
                                  const Icon(Icons.calendar_today),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          const Text('Price'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: '0',
                            ),
                            validator: (v) =>
                            (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),

                          const Text('Category'),
                          const SizedBox(height: 8),

                          Center(
                            child: SizedBox(
                              height: 90,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final c = _categories[index];
                                  final selected = c == _selectedCategory;
                                  return GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedCategory = c),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 32,
                                          backgroundColor: selected
                                              ? const Color(0xff7F56D9)
                                              : Colors.deepPurple[50],
                                          child: Image.asset(
                                            'assets/images/$c.png',
                                            width: 44,
                                            height: 44,
                                            errorBuilder: (cxt, e, s) =>
                                            const Icon(Icons.shopping_bag),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          c,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: selected
                                                ? Colors.black
                                                : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                                itemCount: _categories.length,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: const Color(0xff7F56D9),
                              ),
                              onPressed: _update,
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 3),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _update() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;

    final updated = ExpenseEntity(
      id: widget.expense.id,
      title: title,
      amount: amount,
      date: _selectedDate,
      category: _selectedCategory,
    );

    context.read<ExpenseBloc>().add(UpdateExpenseEvent(updated));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
