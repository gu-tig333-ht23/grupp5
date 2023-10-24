import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:good_morning/data_handling/history_data_storage.dart';

class HistoryItem {
  String historyText;
  String historyThumbnail;
  String historyExtract;

  HistoryItem(
      {required this.historyText, required this.historyThumbnail, required this.historyExtract});

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      historyText: json['text'] as String,
      historyThumbnail: json['thumbnail'] as String,
      historyExtract: json['extract'] as String,
    );
  }
}

class HistoryProvider extends ChangeNotifier {
// Date
  final DateTime _now = DateTime.now();
  DateTime get now => _now;

  get ddDate => _now.day;
  get mmDate => _now.month;

// Filter
  String _selectedFilter = 'events';
  String get selectedFilter => _selectedFilter;

// Random number
  var randomNumber = Random().nextInt(20);

  void setFilter(filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void storeHistory(selectedFilter) {
    storeHistorySetting(selectedFilter);
  }

//Empty history item
  var _historyItem = HistoryItem(
    historyText: '',
    historyThumbnail: '',
    historyExtract: '',
  );
  HistoryItem get historyItem => _historyItem;

  var _storedHistoryItem = HistoryItem(
    historyText: '',
    historyThumbnail: '',
    historyExtract: '',
  );
  HistoryItem get storedHistoryItem => _storedHistoryItem;

  //get HistoryItem from SharedPreferences
  getStoredHistoryData() async {
    var storedHistoryItem = await getHistoryData();
    _storedHistoryItem = HistoryItem.fromJson(storedHistoryItem);
    notifyListeners();
  }

  //Get historyitem from API-function
  fetchHistoryItem() async {
    var historyItemApi = await fetchHistoryItemWiki(
         selectedFilter, now.month, now.day);
    _historyItem = HistoryItem.fromJson(historyItemApi);
    //Store HistoryItem
    print('i Fetch Innan Store');
    print(_historyItem.historyText);
    print(historyItem.historyThumbnail);
    print(historyItem.historyExtract);

    storeHistoryData(
      historyText: _historyItem.historyText, 
      historyThumbnail: _historyItem.historyThumbnail, 
      historyExtract: _historyItem.historyExtract);
    notifyListeners();
  }
  // API function
  Future<Map<String, dynamic>> fetchHistoryItemWiki(
   selectedFilter, month, day) async {
  final apiHeaderWiki = {
    'ContentType': 'application/json',
    'accept': 'application/json',
  };

//https://cors-anywhere.herokuapp.com/
  final response = await http.get(
    Uri.parse(
        'https://en.wikipedia.org/api/rest_v1/feed/onthisday/$selectedFilter/$month/$day'),
    headers: apiHeaderWiki,
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final events = data['$selectedFilter'] as List;
    if (events.isEmpty) {
      print('No items');
      return {
        'text': '',
        'thumbnail': '',
        'extract': '',
      };
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
    } while (thumbnail.isEmpty && nextRandomNumber != randomNumber);

    return {
      'text': text,
      'thumbnail': thumbnail,
      'extract': extract,
    };
  } else {
    throw Exception('Failed to load data from the API');
  }
}
}