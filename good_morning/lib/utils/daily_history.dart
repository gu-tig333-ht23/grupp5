import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class HistoryItem {
  final String text;
  final String title;
  final String thumbnail;
  final String extract;

  HistoryItem(
      {required this.text,
      required this.title,
      required this.thumbnail,
      required this.extract});
}

class HistoryProvider extends ChangeNotifier {
  
var _item = HistoryItem (
        text: '',
        title:'',
        extract:'',
        thumbnail:'',
);
HistoryItem get item => _item;

var randomNumber = Random().nextInt(35);

  String _selectedFilter = 'births';
  String get selectedFilter => _selectedFilter;

  void setFilter(filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  fetchHistoryItem3() async {
    var historyitem = await fetchHistoryItemWiki(randomNumber, selectedFilter);
    _item = historyitem;
    notifyListeners();
  }

// funkar
Future<HistoryItem> fetchHistoryItemWiki(randomNumber, selectedFilter) async {
  final apiHeaderWiki = {
    'ContentType': 'application/json'
        'accept: application/json'
  };
  http.Response response = await http.get(
      Uri.parse(
          'https://en.wikipedia.org/api/rest_v1/feed/onthisday/$selectedFilter/11/11'),
      headers: apiHeaderWiki);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final events = data['$selectedFilter'] as List;
    if (events.isEmpty) {
      return HistoryItem(text: '', title: '', thumbnail: '', extract: '');
    }

    final item = events[randomNumber] as Map<String, dynamic>;
    final text = item['text'] as String;
    final pages = item['pages'] as List;
    final title = pages[0]['title'] as String;
    //Bheövs felhantering här ifall det inte finns bild
    String thumbnail = pages[0]['thumbnail']['source'] as String;
      if (thumbnail.isEmpty) {
        thumbnail ='';
      }
    final extract = pages[0]['extract'] as String;
    return HistoryItem(
        text: text, title: title, thumbnail: thumbnail, extract: extract);
  } else {
    throw Exception('Failed to load data from the API');
  }
}
}
