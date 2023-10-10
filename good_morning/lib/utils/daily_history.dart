import 'dart:convert';

class HistoryItem {
  String text;
  String extract;
  String thumbnail;

  HistoryItem(this.text, this.extract, this.thumbnail);

/*

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
    
      id: json[],
      text: json['userId'],
      id: json['id'],
      title: json['thumbnail'],
    );
  }
*/
}

//Filter
enum types { All, Selected, Births, Deaths, Holidays, Events }

List<HistoryItem> get historyitem => _historyitem;

// Exempel i UI:n
List<HistoryItem> _historyitem = [
  HistoryItem(
      'På den här dagen  för 23 år sedan föddes Penei Sewell (American football player)',
      'massa information här nere, bla bla bla, föddes här, gick i skola där, 350 000 mål förra året. WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Penei_Sewell_%2852480402764%29_%28cropped%29.jpg/320px-Penei_Sewell_%2852480402764%29_%28cropped%29.jpg'),
];

// För API
const String type = 'births';
const String month = '01';
const String day = '09';
const String ENDPOINT =
    'https://en.wikipedia.org/api/rest_v1/#/Feed/onThisDay/$type/$month/$day';
