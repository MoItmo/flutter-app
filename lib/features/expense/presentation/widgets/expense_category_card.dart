import 'package:flutter/material.dart';

class ExpenseCategoryCard extends StatelessWidget {
  final String category;
  final double total;

  const ExpenseCategoryCard({super.key, required this.category, required this.total});

  static const Map<String, String> categoryAssets = {
    'Essentials': 'assets/images/Essentials.png',
    'Personal': 'assets/images/Personal.png',
    'Miscellaneous': 'assets/images/Miscellaneous.png',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF7C3AED)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 6))],
      ),
      height: 110,
      child: Row(
        children: [
          // text info
          Expanded(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text(
                category,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '${total.toStringAsFixed(0)}\$',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),

          // image aligned right
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: SizedBox(
              width: 90,
              height: 90,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: OverflowBox(
                  maxWidth: 140,
                  maxHeight: 140,
                  child: Image.asset(
                    categoryAssets[category] ?? 'assets/images/essentials.png',
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
