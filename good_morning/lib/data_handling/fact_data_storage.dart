import 'package:shared_preferences/shared_preferences.dart';

//Lagring för daily fact

Future<void> storeFactData(
    String factText, List<String> chosenCategories) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('factText', factText);
  prefs.setStringList('chosenCategories', chosenCategories);
}

Future<Map<String, dynamic>> getFactData() async {
  final prefs = await SharedPreferences.getInstance();
  final factText = prefs.getString('factText');
  final chosenCategories = prefs.getStringList('chosenCategories');

  return {
    'factText': factText ?? '',
    'chosenCategories': chosenCategories ?? [],
  };
}