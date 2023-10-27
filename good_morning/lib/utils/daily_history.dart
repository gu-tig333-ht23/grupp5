import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:good_morning/data_handling/history_data_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HistoryItem {
  String historyText;
  String historyThumbnail;
  String historyExtract;
  String historyDate;
  String historyFilter;

  HistoryItem(
      {required this.historyText,
      required this.historyThumbnail,
      required this.historyExtract,
      required this.historyDate,
      required this.historyFilter});

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      historyText: json['historyText'] as String,
      historyThumbnail: json['historyThumbnail'] as String,
      historyExtract: json['historyExtract'] as String,
      historyDate: json['historyDate'] as String,
      historyFilter: json['historyFilter'] as String,
    );
  }
}

class HistoryProvider extends ChangeNotifier {
// Date
  final DateTime _now = DateTime.now();
  DateTime get now => _now;

////
//Datum
  get date => now.month.toString() + now.day.toString();

// Filter
  String _selectedFilter = 'events';
  String get historyFilter => _selectedFilter;

  //Nytt filter
  getSelectedFilter(newFilter) {
    _selectedFilter = newFilter;
    notifyListeners();
    fetchHistoryItem();
  }

//Empty history items
  var _historyItem = HistoryItem(
    historyText: '',
    historyThumbnail: '',
    historyExtract: '',
    historyDate: '',
    historyFilter: '',
  );
  HistoryItem get historyItem => _historyItem;
/*
  var _storedHistoryItem = HistoryItem(
    historyText: '',
    historyThumbnail: '',
    historyExtract: '',
    historyDate: '',
    historyFilter: '',
  );
  HistoryItem get storedHistoryItem => _storedHistoryItem;
*/

  //get HistoryItem from SharedPreferences
  bootHistory() async {
    //print('BOOT');

    var storedHistoryData = await getHistoryData();

    // ignore: unnecessary_null_comparison
    if (storedHistoryData != null) {
      final historyItem = HistoryItem.fromJson(storedHistoryData);

      if (historyItem.historyDate == date) {
        _historyItem = historyItem;
        // print('samma datum = load');
      } else {
        await fetchHistoryItem();
      }
      //print('nytt datum = ny fetch');
    } else {
      //print('fanns inget i minnet = ny fetch');
      await fetchHistoryItem();
    }
    notifyListeners();
  }

  //Get historyitem from API-function
  fetchHistoryItem() async {
    //print('FETCH');
    var historyItemApi =
        await fetchHistoryItemWiki(historyFilter, now.month, now.day);
    _historyItem = historyItemApi;
    //Store HistoryItem
    storeHistoryData(
        historyText: _historyItem.historyText,
        historyThumbnail: _historyItem.historyThumbnail,
        historyExtract: _historyItem.historyExtract,
        historyDate: historyItem.historyDate,
        historyFilter: historyItem.historyFilter);
    //print('FETCH KLAR');
    notifyListeners();
    bootHistory();
    return;
  }


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
      
      /// onödig?
      if (events.isEmpty) {
        print('No items');
        return HistoryItem(
          historyText: '',
          historyThumbnail: '',
          historyExtract: '',
          historyDate: '',
          historyFilter: '',
        );
      }
    //////////////
      var nextRandomNumber = Random().nextInt(events.length);

      if (nextRandomNumber >= events.length) {
        nextRandomNumber = 0; // Wrap around to the beginning of the list
      }
      var item = events[nextRandomNumber] as Map<String, dynamic>;
      final pages = item['pages'] as List;
      var date = month.toString() + day.toString();
      // ignore: unused_local_variable
      String historyThumbnail;
      final thumbnailData = pages[0]['thumbnail'];
          if (thumbnailData != null && thumbnailData['source'] != null) {
            historyThumbnail = thumbnailData['source'] as String;
          } else {
            historyThumbnail = '';
          }

      final historyitem = HistoryItem(
        historyText: item['text'] ?? '',
        historyThumbnail: historyThumbnail,
        historyExtract: pages[0]['extract'] ?? '',
        historyDate: date,
        historyFilter: historyFilter,
      );

      return historyitem;
    } catch (e) {
      print('Error: $e');
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
}




/*

  // API function
  Future<Map<String, dynamic>> fetchHistoryItemWiki(
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
        print('No items');
        return {
          'historyText': '',
          'historyThumbnail': '',
          'historyExtract': '',
          'historyDate': '',
          'historyFilter': '',
        };
      }

      var nextRandomNumber = Random().nextInt(events.length);
      Map<String, dynamic> item;
      String historyText;
      String historyThumbnail;
      String historyExtract;

      do {
        if (nextRandomNumber >= events.length) {
          nextRandomNumber = 0; // Wrap around to the beginning of the list
        }
        item = events[nextRandomNumber] as Map<String, dynamic>;
        historyText = item['text'] as String;
        final pages = item['pages'] as List;
        if (pages.isNotEmpty) {
          final thumbnailData = pages[0]['thumbnail'];
          if (thumbnailData != null && thumbnailData['source'] != null) {
            historyThumbnail = thumbnailData['source'] as String;
          } else {
            historyThumbnail = '';
          }
          historyExtract = pages[0]['extract'] as String;
        } else {
          historyThumbnail = '';
          historyExtract = '';
        }

        nextRandomNumber++;
      } while (historyThumbnail.isEmpty);

      return {
        'historyText': historyText,
        'historyThumbnail': historyThumbnail,
        'historyExtract': historyExtract,
        'historyDate': month.toString() + day.toString(),
        'historyFilter': historyFilter,
      };
    } else {
      throw Exception('Failed to load data from the API');
    }
  }
}

*/
