import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../domian/entity/expense_entity.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({Key? key}) : super(key: key);

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedCategory = 'Essentials';

  final List<String> _categories = ['Essentials', 'Personal', 'Miscellaneous'];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return DraggableScrollableSheet(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add New Expense',
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
                                hintText: _selectedDate == null
                                    ? 'Select date'
                                    : _selectedDate!.toLocal().toString().split(
                                        ' ',
                                      )[0],
                                suffixIcon: const Icon(Icons.calendar_today),
                              ),
                              validator: (v) =>
                                  _selectedDate == null ? 'Required' : null,
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
                                            ? Color(0xff7F56D9)
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
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Color(0xff7F56D9),
                            ),
                            onPressed: _save,
                            child: const Text(
                              'Save',
                              style: TextStyle(fontSize: 16,color: Colors.white),
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
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 3),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final date = _selectedDate ?? DateTime.now();

    final expense = ExpenseEntity(
      id: id,
      title: title,
      amount: amount,
      date: date,
      category: _selectedCategory,
    );

    context.read<ExpenseBloc>().add(AddExpenseEvent(expense));

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
