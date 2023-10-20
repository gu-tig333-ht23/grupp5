import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:good_morning/data_handling/fact_data_storage.dart';
import 'package:good_morning/data_handling/secrets.dart' as config;

// handles all changes to the list with categories
class DailyFactProvider extends ChangeNotifier {
  Future<String> _factText = Future.value('');

  Future<String> get factText => _factText;

  void getFactText() {
    fetchAndUpdateFact();
  }

  // storing the fact text in the storage
  void storeText(text) async {
    await storeFactText(text);
  }

  getStoredText() async {
    var _factText = await getStoredFactData();
    return _factText;
  }

  Future<void> storeDate(date) async {
    await storeFetchedDate(date);
  }

  getDateFromStorage() async {
    var _storedDate = await getStoredDate();
    return _storedDate;
  }

  Future<void> fetchAndUpdateFact() async {
    DateTime storedDate = await getDateFromStorage();
    DateTime currentDate = DateTime.now();
    if (currentDate.isAfter(storedDate.add(Duration(days: 1)))) {
      // last text fetched more than one day ago
      try {
        String factData = await fetchDailyFact(); // fetches new fact
        int startIndex = factData.indexOf('\n\n');
        String factText = factData.substring(startIndex + 2).trim();
        _factText = Future.value(factText);
        storeFactText(factText);

        storeFetchedDate(currentDate);
        print('Stored date for fetching: $currentDate');
        notifyListeners();
      } catch (error) {
        throw Exception('Failed to fetch and update fact text: $error');
      }
    } else {
      // fetch the stored fact text
      Map<String, String> storedData = await getStoredFactData();
      String factText = storedData['factText'] ?? '';
      _factText = Future.value(factText);
    }
    notifyListeners();
  }
}

// Handles all communication with ChatGPT API //

const String factApiKey = config.factApiKey;

const factApiUrl = 'https://api.openai.com/v1/completions';

// Function call to fetch fact from API with current chosen categorynames
Future<String> fetchDailyFact() async {
  String factPrompt = 'Tell me a fun, random fact';

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
