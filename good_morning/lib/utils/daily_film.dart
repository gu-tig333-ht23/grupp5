import 'package:dio/dio.dart';
import 'dart:math';

final Dio dio = Dio();
const String bearerKey =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZWQ2NjJiNzc1MTIxOThmZjBmZTIxNGQwN2ZlZDljNSIsInN1YiI6IjY1MjI2YzM5MDcyMTY2MDExYzA1YzdhNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.le_mcHwYS_PzUQADBaC_XQe0HrFbtTqChmv6J3El3UI';

class FilmApi {
  final Dio dio;

  FilmApi(this.dio);

  // Testing numbers
  String inputYear = '';
  String releaseYear = '';

//Skickar man in en sökning för page 0 får man error
  String pageNumber = '&page=${Random().nextInt(9) + 1}';

  Future<Map<String, dynamic>> getMovie() async {
    dio.options.headers['Authorization'] = 'Bearer $bearerKey';
    dio.options.headers['Accept'] = 'application/json';

    Response response = await dio.get(
      'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US$pageNumber$releaseYear&sort_by=popularity.desc',
    );
    int randomIndex = Random().nextInt(response.data['results'].length);
    Map<String, dynamic> randomMovie = response.data['results'][randomIndex];
    Map<String, dynamic> movieData = {
      'title': randomMovie['title'],
      'description': randomMovie['overview'],
      'release_year': randomMovie['release_date'].toString().substring(0, 4),
      'vote_average': randomMovie['vote_average'].toString(),
      'poster_path': 'https://image.tmdb.org/t/p/w600_and_h900_bestv2' +
          randomMovie['poster_path'],
      'tmdb_id': randomMovie['id'].toString(),
    };

    /////////////////////////
    print(movieData);
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
          'X-RapidAPI-Key':
              'a0b8b17cd6msh95aa41d463d3bf7p13c3c0jsn2b024de57b76',
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
        // List us = streamingInfo['us'];

        // print('SE: $se');
        // print('\n\nSE OVAN US UNDER\n\n');
        // print('US: $us');
      }
    }
  } catch (error) {
    print('Error: $error');
  }
  return result;
}
