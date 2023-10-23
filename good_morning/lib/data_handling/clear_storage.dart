import 'package:shared_preferences/shared_preferences.dart';

// Fil för att radera lagrad data

// OBS! denna funktion raderar all lagrad data i hela appen
// För att radera specifik data, använd relevand funktion nedan 
Future<void> clearAllData() async {
  await clearUserPreferences();
  await clearMovieData();
  await clearFactData();
  await clearHistoryData();
  await clearWeatherData();
}

// Funktion för att radera data kopplad till user preferences
Future<void> clearUserPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('selectedCards');
  prefs.remove('onboardingCompleted');
  prefs.remove('userName');
}

// Funktion för att radera data koplad till daily film
Future<void> clearMovieData() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('movieTitle');
  prefs.remove('movieDescription');
  prefs.remove('movieDate');
  prefs.remove('movieRating');
  prefs.remove('moviePoster');
  prefs.remove('movieId');
  prefs.remove('streamingOptions'); 
}

// Funktion för att radera data kopplad till daily fact
Future<void> clearFactData() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('factText');
  prefs.remove('storedDate');
}

// fanktion för att radera data kopplad till daily history
Future<void> clearHistoryData() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('historyText');
  prefs.remove('historyThumbnail');
  prefs.remove('historyExtract');
  prefs.remove('selectedFilter');
}

// Funktion för att radera data kopplat till väder
Future<void> clearWeatherData() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('weatherString');
}


