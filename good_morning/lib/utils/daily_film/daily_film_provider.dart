import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_film/daily_film_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
