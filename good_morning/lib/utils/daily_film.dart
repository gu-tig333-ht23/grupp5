import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:good_morning/data_handling/film_data_storage.dart';
import 'dart:math';
import 'package:good_morning/data_handling/secrets.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';

final Dio dio = Dio();
String bearerKey = config.movieBearerKey;
String streamKey = config.rapidAPIKey;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class FilmApi {
  final Dio dio;

  FilmApi(this.dio);

  // Testing numbers
  String inputYear = '';

//Skickar man in en sökning för page 0 får man error
  String pageNumber = '&page=${Random().nextInt(9) + 1}';

  Future<Movie> fetchMovie() async {
    dio.options.headers['Authorization'] = 'Bearer $bearerKey';
    dio.options.headers['Accept'] = 'application/json';
    final date = DateTime.now();

    Response response = await dio.get(
      'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US$pageNumber&sort_by=popularity.desc&with_original_language=en',
    );
    print('Api call sent');
    int randomIndex = Random().nextInt(response.data['results'].length);
    Map<String, dynamic> randomMovie = response.data['results'][randomIndex];

    final Movie movie = Movie(
      title: randomMovie['title'],
      description: randomMovie['overview'],
      releaseYear: randomMovie['release_date'].toString().substring(0, 4),
      rating: randomMovie['vote_average'].toString(),
      posterPath:
          'https://image.tmdb.org/t/p/w600_and_h900_bestv2${randomMovie['poster_path']}',
      tmdbId: randomMovie['id'].toString(),
      streamInfo: await fetchStreamInfo(randomMovie['id'].toString()),
      fetchDate: date.toString(),
    );

    storeMovieData(movie);
    return movie;
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

      Set<String> uniqueItems = {};

      for (Map<String, dynamic> serviceInfo in se) {
        String service = serviceInfo['service'];
        String streamingType = serviceInfo['streamingType'];

        String combination = '$service|$streamingType';

        if (!uniqueItems.contains(combination)) {
          uniqueItems.add(combination);

          result.add({'service': service, 'streamingType': streamingType});
        }
      }
    }
  } catch (error) {
    print('Error: $error');
  }
  return result;
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

class MovieProvider with ChangeNotifier {
  Movie _movie = Movie(
    title: 'No movie found',
    description: '',
    releaseYear: '',
    rating: '',
    posterPath: '',
    tmdbId: '',
    streamInfo: [],
    fetchDate: '',
  );

  Movie get movie => _movie;

  void setMovie(Movie movie) {
    _movie = movie;
    notifyListeners();
  }
}

class FavoriteMoviesModel extends ChangeNotifier {
  List<List<String>> _favoriteMovies = [];

  List<List<String>> get favoriteMovies => _favoriteMovies;
  final String _watchlistKey = 'watchlist34';

  Future<void> loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final watchlistJson = prefs.getString(_watchlistKey);

    final List<dynamic> decodedData = jsonDecode(watchlistJson ?? '[]');

    final List<List<String>> watchlist = decodedData.map((movieData) {
      if (movieData is List) {
        return List<String>.from(movieData);
      } else {
        return <String>[];
      }
    }).toList();

    _favoriteMovies = watchlist;
    notifyListeners();
  }

  Future<void> saveWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final watchlistJson = jsonEncode(_favoriteMovies);
    await prefs.setString(_watchlistKey, watchlistJson);
  }

  Future<List> addFavorite(movie) async {
    final String movieTitle = movie.title;
    final String movieDescription = movie.description;
    final String movieDate = movie.releaseYear;
    final String movieRating = movie.rating;
    final String moviePosterPath = movie.posterPath;
    final String tmdbId = movie.tmdbId;
    final List<Map<String, String>> streamInfo = movie.streamInfo;
    final String fetchDate = movie.fetchDate;

    List output = [];

    if (_favoriteMovies.any((movie) => movie[0] == movieTitle)) {
      return output = ['The movie is already in your watchlist', 'Remove'];
    } else {
      if (streamInfo.isNotEmpty) {
        _streamInfoMap[movieTitle] = streamInfo;
      }
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

      saveWatchlist();
      notifyListeners();
      return output = ['Movie added to your watchlist', 'Undo'];
    }
  }

  final Map<String, List<Map<String, String>>> _streamInfoMap = {};

  void removeMovie(int index) {
    final String movieTitle = _favoriteMovies[index][0];
    _favoriteMovies.removeAt(index);
    _streamInfoMap.remove(movieTitle);

    saveWatchlist();
    notifyListeners();
  }
}
