import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:good_morning/utils/daily_history/daily_history_model.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'dart:math';

Future<HistoryItem> fetchHistoryItemWiki(historyFilter, month, day) async {
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
        text: '',
        thumbnail: '',
        extract: '',
        year: '',
      );
    }

    var nextRandomNumber = Random().nextInt(events.length);
    Map<String, dynamic> item;
    String text;
    String thumbnail;
    String extract;
    String year;

    do {
      if (nextRandomNumber >= events.length) {
        nextRandomNumber = Random().nextInt(events.length);
      }
      item = events[nextRandomNumber] as Map<String, dynamic>;
      text = item['text'] as String;
      year = item['year'].toString();
      if (item['year'] == null) {
        year = 'Yearly ';
      }
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
      year: year,
    );
  } else {
    throw Exception('Failed to load data from the API');
  }
}
