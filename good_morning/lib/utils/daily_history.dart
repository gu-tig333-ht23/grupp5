import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:good_morning/data_handling/history_data_storage.dart';

class HistoryItem {
  String text;
  String thumbnail;
  String extract;

  HistoryItem(
      {required this.text, required this.thumbnail, required this.extract});

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      text: json['text'] as String,
      thumbnail: json['thumbnail'] as String,
      extract: json['extract'] as String,
    );
  }

  Map<String, dynamic> json = {
    'text': 'Sample text',
    'thumbnail': 'sample_thumbnail_url',
    'extract': 'Sample extract',
  };
}

class HistoryProvider extends ChangeNotifier {
  

// Date
  final DateTime _now = DateTime.now();
  DateTime get now => _now;

  get ddDate => _now.day;
  get mmDate => _now.month;

// Random number
  var randomNumber = Random().nextInt(1);

// Filter
  String _selectedFilter = 'births';
  String get selectedFilter => _selectedFilter;
  @override
  notifyListeners();

  void setFilter(filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void storeHistory(selectedFilter) {
    storeHistorySetting(selectedFilter);
  }

//Empty history item
  var _item = HistoryItem(
    text: '',
    extract: '',
    thumbnail: '',
  );
  HistoryItem get item => _item;

  getStoredHistoryData() async {
    var _storedData = await getHistoryData();
    return _storedData;
  }

  //Get historyitem from API-function
  fetchHistoryItem3() async {
    var historyitem = await fetchHistoryItemWiki(
        randomNumber, selectedFilter, now.month, now.day);



    _item = HistoryItem.fromJson(historyitem);
    
    

    notifyListeners();
  }

  // API function
  Future<Map<String, dynamic>> fetchHistoryItemWiki(
  randomNumber, selectedFilter, month, day) async {
  final apiHeaderWiki = {
    'ContentType': 'application/json',
    'accept': 'application/json',
  };

  final response = await http.get(
    Uri.parse(
        'https://cors-anywhere.herokuapp.com/https://en.wikipedia.org/api/rest_v1/feed/onthisday/$selectedFilter/$month/$day'),
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

    Map<String, dynamic> item;
    String text;
    String thumbnail;
    String extract;
    int nextRandomNumber = randomNumber;

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