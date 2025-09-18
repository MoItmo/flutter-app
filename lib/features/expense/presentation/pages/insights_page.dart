import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gemini_langchain/gemini_langchain.dart';

import '../../domian/entity/expense_entity.dart';

class InsightsPage extends StatefulWidget {
  final List<ExpenseEntity> expenses;

  const InsightsPage({super.key, required this.expenses});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  final TextEditingController _questionController = TextEditingController();
  String aiResponse = '';
  bool isAIloading = false;

  late Map<String, double> categoryTotals;
  late List<PieChartSectionData> chartSections;

  final LangChain _langChain = LangChain(
    template: '''
You are a smart financial assistant.

Here are the expenses:
{expense_list}

Answer the following question about the spending:
{question}
''',
  );

  @override
  void initState() {
    super.initState();
    _calculateTotals();
  }

  void _calculateTotals() {
    categoryTotals = {};
    for (final e in widget.expenses) {
      categoryTotals[e.title] =
          (categoryTotals[e.title] ?? 0) + e.amount;
    }
    chartSections = _buildChartSections();
  }

  Future<void> _askAI(String question) async {
    if (question.isEmpty) return;

    final expenseListStr = widget.expenses
        .map((e) =>
    '${e.category}: \$${e.amount.toStringAsFixed(2)} - ${e.title}')
        .join('\n');

    final variables = {
      'expense_list': expenseListStr,
      'question': question,
    };

    setState(() {
      aiResponse = '';
      isAIloading = true;
    });

    try {
      await for (final chunk in _langChain.run(variables)) {
        setState(() {
          aiResponse = chunk;
        });
      }
    } catch (e) {
      setState(() {
        aiResponse = 'Error: $e';
      });
    } finally {
      setState(() {
        isAIloading = false;
      });
    }
  }

  List<PieChartSectionData> _buildChartSections() {
    final total = categoryTotals.values.fold(0.0, (a, b) => a + b);
    final random = Random();

    return categoryTotals.entries.map((entry) {
      final percentage = (entry.value / total) * 100;

      return PieChartSectionData(
        color: Color.fromARGB(
          255,
          random.nextInt(200) + 55,
          random.nextInt(200) + 55,
          random.nextInt(200) + 55,
        ),
        value: entry.value,
        title: '${entry.key}\n${percentage.toStringAsFixed(1)}%',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Where is my money going?"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Pie Chart
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: chartSections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Legend
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: chartSections.map((section) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: section.color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        section.title!.split("\n").first,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // AI Input
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Ask AI about your expenses',
                hintText: 'e.g. Where did I spend the most?',
              ),
              minLines: 1,
              maxLines: 3,
            ),
            const SizedBox(height: 12),

            // Ask AI Button
            ElevatedButton.icon(
              icon: isAIloading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.question_answer),
              label: Text(isAIloading ? 'Analyzing...' : 'Ask AI'),
              onPressed: isAIloading
                  ? null
                  : () => _askAI(_questionController.text.trim()),
            ),
            const SizedBox(height: 16),

            // AI Response
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Text(
                  aiResponse,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
