
import 'package:dio/dio.dart';

import 'package:good_morning/data_handling/secrets.dart' as config;


final Dio dio = Dio();
String bearerKey = config.movieBearerKey;
String streamKey = config.rapidAPIKey;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class Movie {
  final String title;
  final String description;
  final String releaseYear;
  final String rating;
  final String posterPath;
  final String tmdbId;
  final List<Map<String, String>> streamInfo;
  final String fetchDate;

  Movie({
    required this.title,
    required this.description,
    required this.releaseYear,
    required this.rating,
    required this.posterPath,
    required this.tmdbId,
    required this.streamInfo,
    required this.fetchDate,
  });
}
