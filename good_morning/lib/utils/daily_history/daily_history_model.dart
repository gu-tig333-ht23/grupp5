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
    print(json);  // Print the entire JSON map for debugging.
  
  final text = json['text'] as String;
  final thumbnail = json['thumbnail'] as String;
  final extract = json['extract'] as String;

  print('Text: $text, Thumbnail: $thumbnail, Extract: $extract');
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