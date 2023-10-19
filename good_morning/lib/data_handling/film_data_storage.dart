import 'package:shared_preferences/shared_preferences.dart';

//Lagring för daily film

Future<void> storeMovieData({
  required String movieTitle,
  required String movieDescription,
  required String movieDate,
  required String movieRating,
  required String moviePoster,
  required String movieId,
}) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('movieTitle', movieTitle);
  prefs.setString('movieDescription', movieDescription);
  prefs.setString('movieDate', movieDate);
  prefs.setString('movieRating', movieRating);
  prefs.setString('moviePoster', moviePoster);
  prefs.setString('movieId', movieId);
  print('Storage printer');
  print(prefs.getString('movieTitle'));
}

Future<Map<String, String>> getMovieData() async {
  final prefs = await SharedPreferences.getInstance();
  final movieTitle = prefs.getString('movieTitle');
  final movieDescription = prefs.getString('movieDescription');
  final movieDate = prefs.getString('movieDate');
  final movieRating = prefs.getString('movieRating');
  final moviePoster = prefs.getString('moviePoster');
  final movieId = prefs.getString('movieId');

  return {
    'movieTitle': movieTitle ?? '',
    'movieDescription': movieDescription ?? '',
    'movieDate': movieDate ?? '',
    'movieRating': movieRating ?? '',
    'moviePoster': moviePoster ?? '',
    'movieId': movieId ?? '',
  };
}

Future<void> storeFilmSettingsData({
  required String releaseYear,
  required String excludedCategory,
}) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('releaseYear', releaseYear);
  prefs.setString('excludedCategory', excludedCategory);
}

Future<Map<String, String>> getSettingsData() async {
  final prefs = await SharedPreferences.getInstance();
  final releaseYear = prefs.getString('releaseYear');
  final excludedCategory = prefs.getString('excludedCategory');

  return {
    'releaseYear': releaseYear ?? '',
    'excludedCategory': excludedCategory ?? '',
  };
}
