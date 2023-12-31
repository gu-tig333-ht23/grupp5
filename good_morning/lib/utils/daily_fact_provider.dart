import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:good_morning/data_handling/fact_data_storage.dart';
import 'package:good_morning/data_handling/secrets.dart' as config;

// handles all changes to the list with categories
class DailyFactProvider extends ChangeNotifier {
  Future<String> _factText = Future.value('');

  Future<String> get factText => _factText;

  DateTime _lastFetchedDate =
      DateTime.now(); // default, to be updated when retrieving factText

  DateTime get lastFetchedDate => _lastFetchedDate;

  DailyFactProvider() {
    getFactText();

    // Schedules a timer to check for a new day and fetch a new factText
    const Duration checkInterval =
        Duration(minutes: 5); // checks every 5 minutes
    Timer.periodic(checkInterval, (timer) {
      DateTime now = DateTime.now();
      //
      if (isDifferentDay(lastFetchedDate, now)) {
        // checks against provider`s variable lastFetchedDate from the last fetch
        // New day has started, fetch a new factText
        fetchAndUpdateFact();
      }
    });
  }

  Future<void> getFactText() async {
    await fetchAndUpdateFact();
  }

  // storing the fact text in the storage
  void storeText(text) async {
    await storeFactText(text);
  }

  Future<String> getStoredText() async {
    String factText = await getStoredFactData();
    return factText;
  }

  Future<void> storeDate(date) async {
    await storeFetchedDate(date);
  }

  Future<DateTime> getDateFromStorage() async {
    var storedDate = await getStoredDate();
    return storedDate;
  }

  // function that checks if the dates are different days
  bool isDifferentDay(DateTime stored, DateTime current) {
    return (stored.year != current.year ||
        stored.month != current.month ||
        stored.day != current.day);
  }

  Future<void> fetchAndUpdateFact() async {
    DateTime storedDate = await getDateFromStorage();
    _lastFetchedDate = storedDate;

    DateTime currentDate = DateTime.now();

    if (isDifferentDay(storedDate, currentDate)) {
      // last text fetched more than one day ago
      try {
        String factData = await fetchDailyFact(); // fetches new fact

        int startIndex = factData.indexOf('\n\n');
        String factText = factData.substring(startIndex + 2).trim();
        _factText = Future.value(factText);
        storeFactText(factText);

        storeFetchedDate(currentDate);
        notifyListeners();
      } catch (error) {
        throw Exception('Failed to fetch and update fact text: $error');
      }
    } else {
      // fetch the stored fact text
      String factText = await getStoredFactData();
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

class DailyFactWidget extends StatelessWidget {
  final Future<String> factText;

  const DailyFactWidget({super.key, required this.factText});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: factText,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            var factText = snapshot.data!;

            return Text(
              factText,
            );
          } else {
            return const Text('No data');
          }
        });
  }
}
