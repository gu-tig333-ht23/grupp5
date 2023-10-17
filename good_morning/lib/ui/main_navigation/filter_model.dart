import 'package:flutter/material.dart';
import 'package:good_morning/data_handling/user_preferences.dart';

class FilterModel extends ChangeNotifier {
  bool _showWeather = true;
  bool _showHistory = true;
  bool _showFact = true;
  bool _showFilm = true;
  bool _showTraffic = true;

  bool get showWeather => _showWeather;
  bool get showHistory => _showHistory;
  bool get showFact => _showFact;
  bool get showFilm => _showFilm;
  bool get showTraffic => _showTraffic;

  FilterModel() {
    loadFromPreferences();
  }

  Future<void> _saveToPreferences() async {
    List<String> selectedCards = [];
    if (_showWeather) selectedCards.add('weather');
    if (_showHistory) selectedCards.add('history');
    if (_showFact) selectedCards.add('fact');
    if (_showFilm) selectedCards.add('film');
    if (_showTraffic) selectedCards.add('traffic');

    await saveUserSelectedCards(selectedCards);
  }

  Future<void> loadFromPreferences() async {
    List<String> selectedCards = await getUserSelectedCards();
    _showWeather = selectedCards.contains('weather');
    _showHistory = selectedCards.contains('history');
    _showFact = selectedCards.contains('fact');
    _showFilm = selectedCards.contains('film');
    _showTraffic = selectedCards.contains('traffic');

    notifyListeners();
  }

  void toggleWeather() {
    _showWeather = !_showWeather;
    _saveToPreferences();
    notifyListeners();
  }

  void toggleHistory() {
    _showHistory = !_showHistory;
    _saveToPreferences();
    notifyListeners();
  }

  void toggleFact() {
    _showFact = !_showFact;
    _saveToPreferences();
    notifyListeners();
  }

  void toggleFilm() {
    _showFilm = !_showFilm;
    _saveToPreferences();
    notifyListeners();
  }

  void toggleTraffic() {
    _showTraffic = !_showTraffic;
    _saveToPreferences();
    notifyListeners();
  }
}
