import 'package:flutter/material.dart';
import 'daily_fact_category_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:good_morning/data_handling/secrets.dart' as config;

// handles all changes to the list with categories
class DailyFactProvider extends ChangeNotifier {
  final List<FactCategory> _categories = [
    (FactCategory(categoryName: 'Animals', chosen: false)),
    (FactCategory(categoryName: 'Natural Science', chosen: false)),
    (FactCategory(categoryName: 'Celebrities', chosen: false)),
    (FactCategory(categoryName: 'Film Science', chosen: false)),
    (FactCategory(categoryName: 'Literature and Reading', chosen: false)),
    (FactCategory(categoryName: 'Space', chosen: false)),
    (FactCategory(categoryName: 'The Human Body', chosen: false)),
    (FactCategory(categoryName: 'History of Sweden', chosen: false)),
    (FactCategory(categoryName: 'Engines and Vehicles', chosen: false)),
    (FactCategory(categoryName: 'Art', chosen: false)),
    (FactCategory(categoryName: 'Psychology and Behaviors', chosen: false)),
    (FactCategory(categoryName: 'Fashion', chosen: false)),
  ];

  String _factText = 'Placeholder';

  List<FactCategory> get categories => _categories;

  String get factText => _factText;

  // function that changes the category´s status when clicked
  void toggleCircle(FactCategory category) {
    category.chosen = !category.chosen;
    notifyListeners();
  }

  // function that retrieves the current chosen categories
  List<String> getChosenCategories() {
    List<String> chosenCategories = categories
        .where((category) => category.chosen)
        .map((category) => category.categoryName)
        .toList();
    return chosenCategories;
  }

  // retrieves the fact text as correct text string to be displayed
  Future<String> fetchFactOfTheDay(List<String> chosenCategories) async {
    try {
      String factData = await fetchDailyFact(chosenCategories);
      int startIndex = factData.indexOf('\n\n');
      String factText = factData.substring(startIndex + 2);
      return factText.trim();
    } catch (error) {
      throw Exception('Failed to fetch fact text: $error');
    }
  }
}

// fetching the daily fact text
Future<String> getDailyFact() async {
  var dailyFactProvider = DailyFactProvider();
  var chosenCats = dailyFactProvider.getChosenCategories();
  String factText = (await fetchDailyFact(chosenCats)).trim();
  return factText;
}

// Handles all communication with ChatGPT API //

const String factApiKey = config.factApiKey;

const factApiUrl = 'https://api.openai.com/v1/completions';

// Function call to fetch fact from API with current chosen categorynames
Future<String> fetchDailyFact(List<String> chosenCategoryNames) async {
  String factPrompt;

  if (chosenCategoryNames.isEmpty) {
    factPrompt = 'Tell me a fun, random fact';
  } else {
    factPrompt =
        'Pick one of these areas of interest: ${chosenCategoryNames.join(', ')} and tell me a fun, random fact from this area. Do not tell me which area you picked.';
  }
  final factHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $factApiKey',
  };

  final factBody = json.encode({
    'prompt': factPrompt,
    'max_tokens': 100,
    'model': 'gpt-3.5-turbo-instruct',
  });

  final response = await http.post(Uri.parse(factApiUrl),
      headers: factHeaders, body: factBody);
  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final String factText = jsonResponse['choices'][0]['text'];
    return factText;
  } else {
    throw Exception('Failed to fetch data from ChatGPT API');
  }
}
