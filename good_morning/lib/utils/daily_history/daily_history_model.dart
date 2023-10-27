class HistoryItem {
  String text;
  String thumbnail;
  String extract;
 
  HistoryItem(
      {required this.text,
      required this.thumbnail,
      required this.extract,
      });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      text: json['text'] as String,
      thumbnail: json['thumbnail'] as String,
      extract: json['extract'] as String,
     
    );
  }
}

class HistorySettings {
  String filter;
  String date;

HistorySettings({
required this.filter,
required this.date,
});

factory HistorySettings.fromJson(Map<String, dynamic> json) {
    return HistorySettings(
      filter: json['filter'] as String,
      date: json['date'] as String,
    );
  }
}