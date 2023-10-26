import 'dart:convert';

import 'package:good_morning/utils/daily_film.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Lagring för daily film

Future<void> storeMovieData(Movie movie) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('movieTitle', movie.title);
  prefs.setString('movieDescription', movie.description);
  prefs.setString('movieDate', movie.releaseYear);
  prefs.setString('movieRating', movie.rating);
  prefs.setString('moviePoster', movie.posterPath);
  prefs.setString('movieId', movie.tmdbId);
  prefs.setString('streamInfo', jsonEncode(movie.streamInfo));
  prefs.setString('fetchDate', movie.fetchDate);
}

Future<Map<String, dynamic>> getMovieData() async {
  final prefs = await SharedPreferences.getInstance();
  final movieTitle = prefs.getString('movieTitle') ?? '';
  final movieDescription = prefs.getString('movieDescription') ?? '';
  final movieDate = prefs.getString('movieDate') ?? '';
  final movieRating = prefs.getString('movieRating') ?? '';
  final moviePoster = prefs.getString('moviePoster') ?? '';
  final movieId = prefs.getString('movieId') ?? '';
  final streamInfoString = prefs.getString('streamInfo') ?? '[]';
  final fetchDate = prefs.getString('fetchDate') ?? '';

  List<Map<String, String>> streamInfo = [];

  try {
    final decodedList = jsonDecode(streamInfoString) as List<dynamic>;
    streamInfo = decodedList.map((item) {
      if (item is Map<String, dynamic>) {
        return item.cast<String, String>();
      }
      return <String, String>{};
    }).toList();
  } catch (e) {
    print('Error parsing streamInfo: $e');
  }

  return {
    'movieTitle': movieTitle,
    'movieDescription': movieDescription,
    'movieDate': movieDate,
    'movieRating': movieRating,
    'moviePoster': moviePoster,
    'movieId': movieId,
    'streamInfo': streamInfo,
    'fetchDate': fetchDate,
  };
}

Future<bool> shouldFetchNewData() async {
  final prefs = await SharedPreferences.getInstance();
  final fetchDate = prefs.getString('fetchDate');

  if (fetchDate == null) {
    print('No fetch date stored, returning true');
    return true;
  }

  final currentDate = DateTime.now();
  final storedDate = DateTime.parse(fetchDate);

  if (currentDate.difference(storedDate).inDays > 0){
  return true;
} else {
  return false;}
}
