import 'package:flutter/material.dart';

class FactCategory {
  final String categoryName;
  bool chosen;

  FactCategory({required this.categoryName, required this.chosen});
}

List<FactCategory> categories = [
  (FactCategory(categoryName: 'Animals', chosen: true)),
  (FactCategory(categoryName: 'Natural Science', chosen: true)),
  (FactCategory(categoryName: 'Celebrities', chosen: false)),
  (FactCategory(categoryName: 'Film Science', chosen: true)),
  (FactCategory(categoryName: 'Literature and Reading', chosen: false)),
  (FactCategory(categoryName: 'Space', chosen: true)),
  (FactCategory(categoryName: 'History of Sweden', chosen: false)),
  (FactCategory(categoryName: 'Engines and Vehicles', chosen: false)),
  (FactCategory(categoryName: 'Art', chosen: false)),
  (FactCategory(categoryName: 'Psychology and Behaviors', chosen: false)),
  (FactCategory(categoryName: 'Fashion', chosen: true)),
];

class FactCategoryItem extends StatelessWidget {
  final FactCategory category;

  FactCategoryItem(this.category);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle,
            color: category.chosen ? Color(0xFFD95524) : Colors.grey),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category.categoryName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
