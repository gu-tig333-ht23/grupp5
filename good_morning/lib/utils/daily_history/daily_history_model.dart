class HistoryItem {
  String historyText;
  String historyThumbnail;
  String historyExtract;
  String historyDate;
  String historyFilter;

  HistoryItem(
      {required this.historyText,
      required this.historyThumbnail,
      required this.historyExtract,
      required this.historyDate,
      required this.historyFilter});

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      historyText: json['historyText'] as String,
      historyThumbnail: json['historyThumbnail'] as String,
      historyExtract: json['historyExtract'] as String,
      historyDate: json['historyDate'] as String,
      historyFilter: json['historyFilter'] as String,
    );
  }
}