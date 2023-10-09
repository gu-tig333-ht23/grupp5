import 'package:flutter/material.dart';
import 'daily_fact.dart';

// handles all changes to the list with categories
class DailyFactList extends ChangeNotifier {
  final List<FactCategory> _categories = [
    (FactCategory(categoryName: 'Animals', chosen: true)),
    (FactCategory(categoryName: 'Natural Science', chosen: true)),
    (FactCategory(categoryName: 'Celebrities', chosen: false)),
    (FactCategory(categoryName: 'Film Science', chosen: true)),
    (FactCategory(categoryName: 'Literature and Reading', chosen: false)),
    (FactCategory(categoryName: 'Space', chosen: true)),
    (FactCategory(categoryName: 'The Human Body', chosen: false)),
    (FactCategory(categoryName: 'History of Sweden', chosen: false)),
    (FactCategory(categoryName: 'Engines and Vehicles', chosen: false)),
    (FactCategory(categoryName: 'Art', chosen: false)),
    (FactCategory(categoryName: 'Psychology and Behaviors', chosen: false)),
    (FactCategory(categoryName: 'Fashion', chosen: true)),
  ];

  List<FactCategory> get categories => _categories;

  // function that changes the category´s status when clicked
  void toggleCircle(FactCategory category) {
    category.chosen = !category.chosen;
    notifyListeners();
  }
}
