import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

//Lagring för daily film

Future<void> storeMovieData({
  required String movieTitle,
  required String movieDescription,
  required String movieDate,
  required String movieRating,
  required String moviePoster,
  required String movieId,
  required List<Map<String, String>> streamInfo,
  required String fetchDate,
}) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('movieTitle', movieTitle);
  prefs.setString('movieDescription', movieDescription);
  prefs.setString('movieDate', movieDate);
  prefs.setString('movieRating', movieRating);
  prefs.setString('moviePoster', moviePoster);
  prefs.setString('movieId', movieId);
  prefs.setString('streamInfo', jsonEncode(streamInfo));
  prefs.setString('fetchDate', fetchDate);
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

  print('Data avaiblie for $currentDate, storedDate: $storedDate');
  return currentDate.difference(storedDate).inDays > 0;
}
