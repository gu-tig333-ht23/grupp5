import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:good_morning/data_handling/secrets.dart';

import 'package:provider/provider.dart';

Future<Map<String, dynamic>> fetchCurrentWeather(BuildContext context) async {
  try {
    final response = await http.get(Uri.parse(weatherAPICurrent));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      Map<String, dynamic> currentWeather = jsonData['current'];
      
      Provider.of<WeatherProvider>(context, listen: false)
          .setWeather(currentWeather);
      return currentWeather;
    } else {
      throw Exception('Failed to load current weather data');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}

class WeatherProvider with ChangeNotifier {
  Map<String, dynamic> _currentWeather = {};

  Map<String, dynamic> get currentWeather => _currentWeather;

  void setWeather(Map<String, dynamic> weatherData) {
    _currentWeather = weatherData;
    notifyListeners();
  }
}

Future<List<Map<String, dynamic>>> fetchHourlyForecast() async {
  try {
    final response = await http.get(Uri.parse(weatherAPIDayForecast));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> hourlyData = jsonData['hourly']['time'];
      List<dynamic> temperatureData = jsonData['hourly']['temperature_2m'];
      List<dynamic> hourlyRain = jsonData['hourly']['rain'];
      List<dynamic> hourlySnow = jsonData['hourly']['snowfall'];

      List<Map<String, dynamic>> hourlyForecast = [];
      for (int i = 0; i < hourlyData.length; i++) {
        hourlyForecast.add({
          'time': hourlyData[i],
          'temperature_2m': temperatureData[i],
          'rain': hourlyRain[i],
          'snowfall': hourlySnow[i],
        });
      }

      return hourlyForecast;
    } else {
      throw Exception('Failed to load hourly forecast data');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}

// Funktion för att extrahera longitud och latitud för inmatad location
Future<String> geocodeLocation(String location) async {
  final apiKey = mapApiKey; // Use the API key from secrets.dart
  final query = Uri.encodeComponent(location);
  final url =
      'https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=$apiKey';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final results = data['results'][0]['geometry']['location'];
        final double lat = results['lat'];
        final double lng = results['lng'];

        String weatherUrl =
            'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&current=temperature_2m,rain,snowfall&hourly=temperature_2m,rain,snowfall&timezone=Europe%2FBerlin&forecast_days=1';

        return weatherUrl;
      }
    }

    // Handle other errors, if needed
    return Future.error('Geocoding failed');
  } catch (e) {
    // Handle exceptions, e.g., network errors
    return Future.error(e.toString());
  }
}

String weatherAPICurrent =
    'https://api.open-meteo.com/v1/forecast?latitude=57.7072&longitude=11.9668&current=temperature_2m,rain,snowfall&hourly=temperature_2m,rain,snowfall&timezone=Europe%2FBerlin&forecast_days=1';

String weatherAPIDayForecast =
    'https://api.open-meteo.com/v1/forecast?latitude=57.7072&longitude=11.9668&current=temperature_2m,rain,snowfall&hourly=temperature_2m,rain,snowfall&timezone=Europe%2FBerlin&forecast_days=1';

Future<void> updateWeatherUrls(String location) async {
  try {
    String weatherUrl = await geocodeLocation(location);
    weatherAPICurrent = weatherUrl;
    weatherAPIDayForecast = weatherUrl;
  } catch (error) {
    print('Error: $error');
  }
}

