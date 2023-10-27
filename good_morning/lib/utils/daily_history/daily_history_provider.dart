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
    text: '',
    thumbnail: '',
    extract: '',
  );
  HistoryItem get historyItem => _historyItem;

  var _historySettings = HistorySettings(
    filter: '',
    date:'',
  );
  
  HistorySettings get historySettings => _historySettings;

  //get HistoryItem from SharedPreferences
  bootHistory() async {
    var storedHistoryData = await getHistoryData();
    var storedHistorySettings = await getHistorySettings();
    // ignore: unnecessary_null_comparison
    if (storedHistoryData != null && storedHistorySettings !=null) {
      final historyItem = HistoryItem.fromJson(storedHistoryData);
      final historySettings = HistorySettings.fromJson(storedHistorySettings);
      if (historySettings.date == date) {
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
        text: _historyItem.text,
        thumbnail: _historyItem.thumbnail,
        extract: _historyItem.extract,
        );
    storeHistorySettings(filter: historyFilter, date: date);
    notifyListeners();
    bootHistory();
    return;
  }

}