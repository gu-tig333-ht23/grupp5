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
  var randomNumber = Random().nextInt(20);

// Filter
  String _selectedFilter = 'births';
  String get selectedFilter => _selectedFilter;

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

//Get historyitem from API-function
  fetchHistoryItem3() async {
    var historyitem = await fetchHistoryItemWiki(
        randomNumber, selectedFilter, now.month, now.day);
    _item = HistoryItem.fromJson(historyitem);
    
    storeHistoryData(_item.text, _item.thumbnail, item.extract);
        
    notifyListeners();
  }

  getStoredHistoryData() async {
    var _storedData = await getHistoryData();
    return _storedData;
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
        return {
          'text': '',
          'thumbnail': '',
          'extract': '',
        };
      }

      final item = events[randomNumber] as Map<String, dynamic>;
      final text = item['text'] as String;
      final pages = item['pages'] as List;
      String thumbnail = pages[0]['thumbnail']['source'] as String;
      final extract = pages[0]['extract'] as String;

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
