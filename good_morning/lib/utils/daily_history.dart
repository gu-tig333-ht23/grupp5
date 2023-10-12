import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryItem {
  String text;
  String title;
  String thumbnail;
  String extract;

  HistoryItem(
      {required this.text,
      required this.title,
      required this.thumbnail,
      required this.extract});
}

class HistoryProvider extends ChangeNotifier {
  String filter = 'All';
  List<HistoryItem> get historyitem => _historyitem;
  List<HistoryItem> _historyitem = [
    HistoryItem(
        text: 'någontoing här',
        title:
            'På den här dagen  för 23 år sedan föddes Penei Sewell (American football player)',
        extract:
            'massa information här nere, bla bla bla, föddes här, gick i skola där, 350 000 mål förra året. WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW',
        thumbnail:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Penei_Sewell_%2852480402764%29_%28cropped%29.jpg/320px-Penei_Sewell_%2852480402764%29_%28cropped%29.jpg'),
  ];

  // Funktion som hämtar på typ 'Selected',
  void fetchHistoryItem() async {
    var historyitem = await getHistoryItem();
    _historyitem = historyitem;
    notifyListeners();
  }

  fetchHistoryItem3() async {
    var historyitem = await fetchHistoryItem_wiki_();
    _historyitem.add(historyitem);
    notifyListeners();
  }
// NINJA API
  String api_key = 'rXr/rqZ6hefB48q+tMQ4GA==FPCM2oZPXPpHvDNY';
  String text = 'roman empire';
  String api_url =
      'https://api.api-ninjas.com/v1/historicalevents?text=roman empire';

  final apiHeader = {
    'X-Api-Key': 'rXr/rqZ6hefB48q+tMQ4GA==FPCM2oZPXPpHvDNY',
    'ContentType': 'application/json'
  };

  Future<List<HistoryItem>> getHistoryItem() async {
    http.Response response = await http.get(
      Uri.parse(api_url),
      headers: apiHeader,
    );
    final List<dynamic> jsonResponse = json.decode(response.body);
    print(jsonResponse);
    return [];
  }
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
    print(response.body);
    final births = data['births'] as List;
    if (births.isEmpty) {
      return HistoryItem(text: '', title: '', thumbnail: '', extract: '');
    }

    final firstBirth = births[0] as Map<String, dynamic>;
    final text = firstBirth['text'] as String;
    final pages = firstBirth['pages'] as List;
    final title = pages[0]['title'] as String;
    final thumbnail = pages[0]['content_urls']['desktop']['page'] as String;
    final extract = pages[0]['extract'] as String;
    print(text);
    return HistoryItem(
        text: text, title: title, thumbnail: thumbnail, extract: extract);
  } else {
    throw Exception('Failed to load data from the API');
  }
}
