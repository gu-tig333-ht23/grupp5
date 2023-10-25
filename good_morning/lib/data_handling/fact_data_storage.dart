import 'package:shared_preferences/shared_preferences.dart';

// Persistent storage for Daily Fact

Future<void> storeFactText(String factText) async {
  try {
    if (factText.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('factText', factText);
    }
  } catch (error) {
    print('Error storing factText: $error');
  }
}

Future<void> storeFetchedDate(DateTime date) async {
  final prefs = await SharedPreferences.getInstance();
  // converting DateTime to String before storing
  String dateString = date.toIso8601String();
  prefs.setString('storedDate', dateString);
}

Future<String> getStoredFactData() async {
  final prefs = await SharedPreferences.getInstance();
  final factText = prefs.getString('factText');

  return factText ?? '';
}

Future<DateTime> getStoredDate() async {
  final prefs = await SharedPreferences.getInstance();
  String? dateString = prefs.getString('storedDate');
  // Parse the stored string back to DateTime
  if (dateString != null) {
    try {
      DateTime storedDate = DateTime.parse(dateString);
      print('Stored date is: $storedDate');
      return storedDate;
    } catch (error) {
      print('Error parsing stored date: $error');
    }
  }
  print('No stored date yet, returns yesterday`s date');
  return DateTime.now().subtract(
      (Duration(days: 1))); // yesterday`s date, if no date is stored yet
}
