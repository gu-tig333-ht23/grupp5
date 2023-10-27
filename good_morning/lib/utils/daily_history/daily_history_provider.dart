import 'package:flutter/material.dart';
import 'package:good_morning/data_handling/history_data_storage.dart';
import 'package:good_morning/utils/daily_history/daily_history_model.dart';
import 'package:good_morning/utils/daily_history/daily_history_api.dart';
class HistoryProvider extends ChangeNotifier {
// Date
  final DateTime _now = DateTime.now();
  DateTime get now => _now;

//Datum
  get date => now.month.toString() + now.day.toString();

// Filter
  String _selectedFilter = 'events';
  String get historyFilter => _selectedFilter;

  //Nytt filter
  getSelectedFilter(newFilter) {
    _selectedFilter = newFilter;
    notifyListeners();
    fetchHistoryItem();
  }

//Empty history items
  var _historyItem = HistoryItem(
    historyText: '',
    historyThumbnail: '',
    historyExtract: '',
    historyDate: '',
    historyFilter: '',
  );
  HistoryItem get historyItem => _historyItem;

  //get HistoryItem from SharedPreferences
  bootHistory() async {
    var storedHistoryData = await getHistoryData();

    // ignore: unnecessary_null_comparison
    if (storedHistoryData != null) {
      final historyItem = HistoryItem.fromJson(storedHistoryData);
      if (historyItem.historyDate == date) {
        _historyItem = historyItem;
      } else {
        await fetchHistoryItem();
      }
    } else {
      await fetchHistoryItem();
    }
    notifyListeners();
  }

  //Get historyitem from API-function
  fetchHistoryItem() async {
    var historyItemApi =
        await fetchHistoryItemWiki(historyFilter, now.month, now.day);
    _historyItem = historyItemApi;
    storeHistoryData(
        historyText: _historyItem.historyText,
        historyThumbnail: _historyItem.historyThumbnail,
        historyExtract: _historyItem.historyExtract,
        historyDate: historyItem.historyDate,
        historyFilter: historyItem.historyFilter);
    notifyListeners();
    bootHistory();
    return;
  }

}