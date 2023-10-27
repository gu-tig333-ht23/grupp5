import 'package:shared_preferences/shared_preferences.dart';

//Lagring för daily history
//Byt ut 'weatherString' mot vad som egentligen ska lagras

Future<void> storeWeatherData(String weatherString) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('weatherString', weatherString);
}

Future<Map<String, dynamic>> getHistoryData() async {
  final prefs = await SharedPreferences.getInstance();
  final weatherString = prefs.getString('weatherString');

  return {
    'weatherString': weatherString ?? '',
  };
}
