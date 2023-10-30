import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:good_morning/data_handling/film_data_storage.dart';
import 'dart:math';
import 'package:good_morning/data_handling/secrets.dart' as config;
import 'package:good_morning/utils/daily_film/daily_film_model.dart';

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

  Future<Movie> fetchMovie() async {
    dio.options.headers['Authorization'] = 'Bearer $bearerKey';
    dio.options.headers['Accept'] = 'application/json';
    final date = DateTime.now();

    Response response = await dio.get(
      'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US$pageNumber&sort_by=popularity.desc&with_original_language=en',
    );
    if (kDebugMode) {
      print('Api call sent');
    }
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
      if (kDebugMode) {
        print('No streaming services found');
      }
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
    if (kDebugMode) {
      print('Error: $error');
    }
  }
  return result;
}
