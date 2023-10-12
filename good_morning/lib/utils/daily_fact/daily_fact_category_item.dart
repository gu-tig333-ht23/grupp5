import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_fact/daily_fact_provider.dart';
import 'package:provider/provider.dart';

class FactCategory {
  final String categoryName;
  bool chosen;

  FactCategory({required this.categoryName, required this.chosen});
}

class FactCategoryItem extends StatelessWidget {
  final bool isClickable;
  final FactCategory category;

  FactCategoryItem(this.category, this.isClickable);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.circle,
              color: category.chosen ? Color(0xFFD95524) : Colors.grey),
          onPressed: () {
            isClickable
                ? Provider.of<DailyFactProvider>(context, listen: false)
                    .toggleCircle(category)
                : null;
          },
        ),
        Text(
          category.categoryName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
