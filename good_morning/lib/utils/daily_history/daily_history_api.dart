import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:good_morning/utils/daily_history/daily_history_model.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'dart:math';

/*
// API function1
  Future<HistoryItem> fetchHistoryItemWiki(historyFilter, month, day) async {
  final apiHeaderWiki = {
    'ContentType': 'application/json',
    'accept': 'application/json',
  };
  String wikiUrl;
  if (kIsWeb) {
    wikiUrl =
        'https://cors-anywhere.herokuapp.com/https://en.wikipedia.org/api/rest_v1/feed/onthisday';
  } else {
    wikiUrl = 'https://en.wikipedia.org/api/rest_v1/feed/onthisday';
  }

  final response = await http.get(
    Uri.parse('$wikiUrl/$historyFilter/$month/$day'),
    headers: apiHeaderWiki,
  );
// mer arbete här
  try {
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final events = data['$historyFilter'] as List;

      var nextRandomNumber = Random().nextInt(events.length);

      if (nextRandomNumber >= events.length) {
        nextRandomNumber = 0; // Wrap around to the beginning of the list
      }
      var item = events[nextRandomNumber] as Map<String, dynamic>;
      return HistoryItem.fromJson(item);
    }
  } catch (e) {
    if (kDebugMode) {
      print('An error occurred: $e');
    }
    throw Exception('Failed to load from API');
  }

  // Add a default return statement here, for example:
  return HistoryItem(
    text: 'no text',
    thumbnail: 'no thumbnail',
    extract: 'no extract',
  ); // You should adjust this based on your actual data structure.
}
*/

//API-function2

  Future<HistoryItem> fetchHistoryItemWiki(
      historyFilter, month, day) async {
    final apiHeaderWiki = {
      'ContentType': 'application/json',
      'accept': 'application/json',
    };

    String wikiUrl;
    if (kIsWeb) {
      // for running in web browsers, sends request through proxy server https://cors-anywhere.herokuapp.com (click there for access first!)
      wikiUrl =
          'https://cors-anywhere.herokuapp.com/https://en.wikipedia.org/api/rest_v1/feed/onthisday';
    } else {
      // for running in emulators, without proxy
      wikiUrl = 'https://en.wikipedia.org/api/rest_v1/feed/onthisday';
    }

//for WEB: https://cors-anywhere.herokuapp.com/
    final response = await http.get(
      Uri.parse('$wikiUrl/$historyFilter/$month/$day'),
      headers: apiHeaderWiki,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final events = data['$historyFilter'] as List;
      if (events.isEmpty) {
        if (kDebugMode) {
          print('No items');
        }
        return HistoryItem(
          text:'',
          thumbnail: '',
          extract: '',
        );
      }

      var nextRandomNumber = Random().nextInt(events.length);
      Map<String, dynamic> item;
      String text;
      String thumbnail;
      String extract;

      do {
        if (nextRandomNumber >= events.length) {
          nextRandomNumber = 0; // Wrap around to the beginning of the list
        }
        item = events[nextRandomNumber] as Map<String, dynamic>;
        text = item['text'] as String;
        final pages = item['pages'] as List;
        if (pages.isNotEmpty) {
          final thumbnailData = pages[0]['thumbnail'];
          if (thumbnailData != null && thumbnailData['source'] != null) {
            thumbnail = thumbnailData['source'] as String;
          } else {
            thumbnail = '';
          }
          extract = pages[0]['extract'] as String;
        } else {
          thumbnail = '';
          extract = '';
        }

        nextRandomNumber++;
      } while (thumbnail.isEmpty);

      return HistoryItem(
        text: text,
        thumbnail: thumbnail,
        extract: extract,
      );
    } else {
      throw Exception('Failed to load data from the API');
    }
  }