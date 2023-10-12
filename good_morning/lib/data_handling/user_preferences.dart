import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserSelectedCards(List<String> selectedCardKeys) async {
  // Implement code to save selected card keys to SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('selectedCards', selectedCardKeys);
}

Future<List<String>> getUserSelectedCards() async {
  // Implement code to retrieve selected card keys from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('selectedCards') ?? [];
}
