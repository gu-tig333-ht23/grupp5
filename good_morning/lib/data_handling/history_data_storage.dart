import 'package:shared_preferences/shared_preferences.dart';

//Lagring för daily history
//Byt ut 'historyString' mot vad som egentligen ska lagras

Future<void> storeHistoryData(
    String historyString
    ) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('historyString', historyString);
}

Future<Map<String, dynamic>> getHistoryData() async {
  final prefs = await SharedPreferences.getInstance();
  final historyString = prefs.getString('historyString');
  

  return {
    'historyString': historyString ?? '',
  };
}