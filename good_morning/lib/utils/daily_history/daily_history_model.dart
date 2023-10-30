class HistoryItem {
  String text;
  String thumbnail;
  String extract;
  String year;

  HistoryItem(
      {required this.text,
      required this.thumbnail,
      required this.extract,
      required this.year});

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      text: json['text'] as String,
      thumbnail: json['thumbnail'] as String,
      extract: json['extract'] as String,
      year: json['year'] as String,
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
