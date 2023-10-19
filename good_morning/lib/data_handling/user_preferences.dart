import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserSelectedCards(List<String> selectedCardKeys) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('selectedCards', selectedCardKeys);
}

Future<List<String>> getUserSelectedCards() async {
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
  String? fetchedName = prefs.getString('userName');
  if (fetchedName == null || fetchedName.trim().isEmpty) {
    return 'Developer'; // Default name for development
  }
  return fetchedName;
}
