import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:good_morning/data_handling/film_data_storage.dart';
import 'dart:math';
import 'package:good_morning/data_handling/secrets.dart' as config;

final Dio dio = Dio();
String bearerKey = config.movieBearerKey;
String streamKey = config.rapidAPIKey;

class FilmApi {
  final Dio dio;

  FilmApi(this.dio);

  // Testing numbers
  String inputYear = '';

//Skickar man in en sökning för page 0 får man error
  String pageNumber = '&page=${Random().nextInt(9) + 1}';

  Future<Map<String, dynamic>> fetchMovie() async {
    dio.options.headers['Authorization'] = 'Bearer $bearerKey';
    dio.options.headers['Accept'] = 'application/json';
    final date = DateTime.now();

    Response response = await dio.get(
      'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US$pageNumber&sort_by=popularity.desc&with_original_language=en',
    );
    print('Api call sent');
    int randomIndex = Random().nextInt(response.data['results'].length);
    Map<String, dynamic> randomMovie = response.data['results'][randomIndex];

    Map<String, dynamic> movieData = {
      'title': randomMovie['title'],
      'description': randomMovie['overview'],
      'release_year': randomMovie['release_date'].toString().substring(0, 4),
      'vote_average': randomMovie['vote_average'].toString(),
      'poster_path':
          'https://image.tmdb.org/t/p/w600_and_h900_bestv2${randomMovie['poster_path']}',
      'tmdb_id': randomMovie['id'].toString(),
      //'streamingInfo': '',
      'streamingInfo': await fetchStreamInfo(randomMovie['id'].toString()),
      'fetchDate': date.toString(),
    };

    storeMovieData(
        movieTitle: movieData['title'],
        movieDescription: movieData['description'],
        movieDate: movieData['release_year'],
        movieRating: movieData['vote_average'],
        moviePoster: movieData['poster_path'],
        movieId: movieData['tmdb_id'],
        streamInfo: movieData['streamingInfo'],
        fetchDate: movieData['fetchDate']);
    return movieData;
  }
}

Future<List<Map<String, String>>> fetchStreamInfo(String movieId) async {
  Dio dio = Dio();
  List<Map<String, String>> result = [];

  try {
    Response response = await dio.get(
      'https://streaming-availability.p.rapidapi.com/get?output_language=en&tmdb_id=movie%2F$movieId',
      options: Options(
        headers: {
          'X-RapidAPI-Host': 'streaming-availability.p.rapidapi.com',
          'X-RapidAPI-Key': streamKey
        },
      ),
    );
    Map<String, dynamic> jsonResponse = response.data;

    Map<String, dynamic> streamingInfo =
        jsonResponse['result']['streamingInfo'];

    if (streamingInfo['se'] == null) {
      print('No streaming services found');
    } else {
      List se = streamingInfo['se'];

      Set<String> uniqueItems = Set();

      for (Map<String, dynamic> serviceInfo in se) {
        String service = serviceInfo['service'];
        String streamingType = serviceInfo['streamingType'];

        String combination = '$service|$streamingType';

        if (!uniqueItems.contains(combination)) {
          uniqueItems.add(combination);

          result.add({'service': service, 'streamingType': streamingType});

          print('Service: $service, Streaming Type: $streamingType');
        }
      }
    }
  } catch (error) {
    print('Error: $error');
  }
  return result;
}

class MovieProvider with ChangeNotifier {
  String _movieTitle = '';
  String _movieDescription = '';
  String _movieDate = '';
  String _movieRating = '';
  String _moviePosterPath = '';
  String _movieId = '';
  List<Map<String, String>> _streamInfo = [];
  String _fetchDate = '';

  String get movieTitle => _movieTitle;
  String get movieDescription => _movieDescription;
  String get movieDate => _movieDate;
  String get movieRating => _movieRating;
  String get moviePosterPath => _moviePosterPath;
  String get movieId => _movieId;
  List<Map<String, String>> get streamInfo => _streamInfo;
  String get fetchDate => _fetchDate;

  void setMovie(
      String title,
      String description,
      String date,
      String rating,
      String posterPath,
      String id,
      List<Map<String, String>> streamInfo,
      String fetchDate) {
    _movieTitle = title;
    _movieDescription = description;
    _movieDate = date;
    _movieRating = rating;
    _moviePosterPath = posterPath;
    _movieId = id;
    _streamInfo = streamInfo;
    _fetchDate = fetchDate;
    notifyListeners();
  }
}

class FavoriteMoviesModel extends ChangeNotifier {
  List<List<String>> _favoriteMovies = [];

  List<List<String>> get favoriteMovies => _favoriteMovies;

  Future<String> addFavorite(
    String movieTitle,
    String movieDescription,
    String movieDate,
    String movieRating,
    String moviePosterPath,
    String tmdbId,
    List<Map<String, String>> streamInfo,
    String fetchDate,
  ) async {
    if (_favoriteMovies.any((movie) => movie[0] == movieTitle)) {
      return 'Movie already in your watchlist';
    } else {
      List<String> favoriteMovie = [
        movieTitle,
        movieDescription,
        movieDate,
        movieRating,
        moviePosterPath,
        tmdbId,
        streamInfo.toString(),
        fetchDate,
      ];
      _favoriteMovies.add(favoriteMovie);
      notifyListeners();
      return 'Movie added to your watchlist';
    }
  }

  void removeMovie(int index) {
    _favoriteMovies.removeAt(index);
    notifyListeners();
  }
}
