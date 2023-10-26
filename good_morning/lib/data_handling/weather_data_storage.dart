import 'package:shared_preferences/shared_preferences.dart';
import 'package:good_morning/utils/weather.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

Future<Map<String, dynamic>> fetchCurrentWeather() async {
  try {
    final response = await http.get(Uri.parse(weatherAPICurrent));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      Map<String, dynamic> currentWeather = jsonData['current'];
      double currentTemp = currentWeather['temperature_2m'] ?? 0.0;
      double currentRain = currentWeather['rain'] ?? 0.0;
      double currentSnow = currentWeather['snowfall'] ?? 0.0;
      return currentWeather;
    } else {
      throw Exception('Failed to load current weather data');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}
