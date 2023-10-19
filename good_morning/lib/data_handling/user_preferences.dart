import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserSelectedCards(List<String> selectedCardKeys ) async {
  // Implement code to save selected card keys to SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('selectedCards', selectedCardKeys);
}

Future<List<String>> getUserSelectedCards() async {
  // Implement code to retrieve selected card keys from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('selectedCards') ?? [];
}

Future<void> setOnboardingCompleted(bool completed) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('onboardingCompleted', completed);
}

Future<bool> isOnboardingCompleted() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboardingCompleted') ?? false;
}

Future<void> setUserName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userName', name);
}

Future<String> getUserName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userName') ?? '';
}
