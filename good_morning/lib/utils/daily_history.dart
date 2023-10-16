import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  fetchHistoryItem3() async {
    var historyitem = await fetchHistoryItem_wiki_();
    _item = historyitem;
    notifyListeners();
  }

// funkar
Future<HistoryItem> fetchHistoryItem_wiki_() async {
  final apiHeader_wiki = {
    'ContentType': 'application/json'
        'accept: application/json'
  };
  http.Response response = await http.get(
      Uri.parse(
          'https://en.wikipedia.org/api/rest_v1/feed/onthisday/births/11/11'),
      headers: apiHeader_wiki);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final births = data['births'] as List;
    if (births.isEmpty) {
      return HistoryItem(text: '', title: '', thumbnail: '', extract: '');
    }

    final firstBirth = births[0] as Map<String, dynamic>;
    final text = firstBirth['text'] as String;
    final pages = firstBirth['pages'] as List;
    final title = pages[0]['title'] as String;
    final thumbnail = pages[0]['thumbnail']['source'] as String;
    final extract = pages[0]['extract'] as String;
    return HistoryItem(
        text: text, title: title, thumbnail: thumbnail, extract: extract);
  } else {
    throw Exception('Failed to load data from the API');
  }
}
}


