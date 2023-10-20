import 'package:shared_preferences/shared_preferences.dart';

//Lagring för daily fact

Future<void> storeFactText(String factText) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('factText', factText);
}

Future<void> storeFetchedDate(DateTime date) async {
  final prefs = await SharedPreferences.getInstance();
  // converting DateTime to String before storing
  String dateString = date.toIso8601String();
  prefs.setString('storedDate', dateString);
}

Future<Map<String, String>> getStoredFactData() async {
  final prefs = await SharedPreferences.getInstance();
  final factText = prefs.getString('factText');

  return {
    'factText': factText ?? '',
  };
}

Future<DateTime?> getStoredDate() async {
  final prefs = await SharedPreferences.getInstance();
  String? dateString = prefs.getString('storedDate');
  // Parse the stored string back to DateTime
  if (dateString != null) {
    try {
      DateTime storedDate = DateTime.parse(dateString);
      return storedDate;
    } catch (error) {
      print('Error parsing stored date: $error');
    }
  }
  return DateTime.now().subtract(
      (Duration(days: 1))); // yesterday`s date, if no date is stored yet
}
