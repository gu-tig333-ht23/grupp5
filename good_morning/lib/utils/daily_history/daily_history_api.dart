import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:good_morning/utils/daily_history/daily_history_model.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'dart:math';

// API function
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
//for WEB: https://cors-anywhere.herokuapp.com/
    final response = await http.get(
      Uri.parse('$wikiUrl/$historyFilter/$month/$day'),
      headers: apiHeaderWiki,
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = json.decode(response.body);
        final events = data['$historyFilter'] as List;
        var nextRandomNumber = Random().nextInt(events.length);

        if (nextRandomNumber >= events.length) {
          nextRandomNumber = 0; // Wrap around to the beginning of the list
        }
        var item = events[nextRandomNumber] as Map<String, dynamic>;
        final pages = item['pages'] as List;
        var date = month.toString() + day.toString();

        String thumbnail = '';
        if (pages.isNotEmpty) {
          final thumbnailData = pages[0]['thumbnail'];
          if (thumbnailData != null && thumbnailData['source'] != null) {
            thumbnail = thumbnailData['source'] as String;
          } else {
            thumbnail = '';
          }
        }

        final historyitem = HistoryItem(
          historyText: item['text'] ?? '',
          historyThumbnail: thumbnail,
          historyExtract: pages[0]['extract'] ?? '',
          historyDate: date,
          historyFilter: historyFilter,
        );

        return historyitem;
      } catch (e) {
        if (kDebugMode) {
          print('Error: $e');
        }
        return HistoryItem(
          historyText: '',
          historyThumbnail: '',
          historyExtract: '',
          historyDate: '',
          historyFilter: '',
        );
      }
    } else {
      // Handle the case where response.statusCode is not 200.
      return HistoryItem(
        historyText: '',
        historyThumbnail: '',
        historyExtract: '',
        historyDate: '',
        historyFilter: '',
      );
    }
  }

