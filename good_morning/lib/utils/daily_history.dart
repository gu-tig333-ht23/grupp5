import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:good_morning/data_handling/history_data_storage.dart';

class HistoryItem {
  String historyText;
  String historyThumbnail;
  String historyExtract;
  int historyDate;

  HistoryItem(
      {required this.historyText,
      required this.historyThumbnail,
      required this.historyExtract,
      required this.historyDate});

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      historyText: json['historyText'] as String,
      historyThumbnail: json['historyThumbnail'] as String,
      historyExtract: json['historyExtract'] as String,
      historyDate: json['historyDate']as int,
    );
  }
}

class HistoryProvider extends ChangeNotifier {
// Date
  final DateTime _now = DateTime.now();
  DateTime get now => _now;

  //Testing
  //DatumTest
  int get day2 => now.day +1;
  int get month2 => now.day +1;
  get date2 => day2+month2;
//

  get date => now.day + now.month;

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
    historyDate: 0,
  );
  HistoryItem get historyItem => _historyItem;

  var _storedHistoryItem = HistoryItem(
    historyText: '',
    historyThumbnail: '',
    historyExtract: '',
    historyDate: 0,
  );
  HistoryItem get storedHistoryItem => _storedHistoryItem;

  //get HistoryItem from SharedPreferences
  getStoredHistoryData() async {
  print('i BÖRJAN get stored history data i daily_history i dart');
  var storedHistoryData = await getHistoryData();

  // ignore: unnecessary_null_comparison
  if (storedHistoryData != null) {
    final storedHistoryItem = HistoryItem.fromJson(storedHistoryData);
    
    if (storedHistoryItem.historyDate == date) {
      _storedHistoryItem = storedHistoryItem;
      print('i datumväljandet');
      print(storedHistoryItem.historyDate);
      print(date);
    } else {
      await fetchHistoryItem();
    }
  } else {
    await fetchHistoryItem();
  }

  print('KLAR stored history data i daily_history i dart');
  notifyListeners();
}
  //Get historyitem from API-function
  fetchHistoryItem() async {
    print('i BÖRJAN fetch history data i daily_history i dart');
    var historyItemApi =
        await fetchHistoryItemWiki(selectedFilter, now.month, now.day);
    _historyItem = HistoryItem.fromJson(historyItemApi);
    
    print('i Fetch Innan Store');
    print(_historyItem.historyText);
    print(historyItem.historyThumbnail);
    print(historyItem.historyExtract);
    print(historyItem.historyDate);
    //Store HistoryItem
    storeHistoryData(
        historyText: _historyItem.historyText,
        historyThumbnail: _historyItem.historyThumbnail,
        historyExtract: _historyItem.historyExtract,
        historyDate: historyItem.historyDate);
    print('i SLUTET fetch, STORE GJORD, i daily_history i dart');
    notifyListeners();
    getStoredHistoryData();
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
          'historyText': '',
          'historyThumbnail': '',
          'historyExtract': '',
          'historyDate': 0,
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
      } while (historyThumbnail.isEmpty && nextRandomNumber != randomNumber);

      return {
        'historyText': historyText,
        'historyThumbnail': historyThumbnail,
        'historyExtract': historyExtract,
        'historyDate': month+day,
      };
    } else {
      throw Exception('Failed to load data from the API');
    }
  }
}
