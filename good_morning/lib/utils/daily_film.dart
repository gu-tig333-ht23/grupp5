import 'package:dio/dio.dart';
import 'dart:math';

const String apiKey = '28710339';
const String endPoint = 'http://www.omdbapi.com/?apikey=&';
const String randomerApiKey = 'd6e8735d5fe74c9d95c1950a6474b249';

final Dio dio = Dio();
const String bearerKey =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZWQ2NjJiNzc1MTIxOThmZjBmZTIxNGQwN2ZlZDljNSIsInN1YiI6IjY1MjI2YzM5MDcyMTY2MDExYzA1YzdhNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.le_mcHwYS_PzUQADBaC_XQe0HrFbtTqChmv6J3El3UI';

class FilmApi {
  final Dio dio;
  FilmApi(this.dio);

  //Testing numbers
  String releaseYear = '2021';

  String pageNumber = '&page=${Random().nextInt(20)}';

  Future<Map<String, dynamic>> getMovie() async {
    dio.options.headers['Authorization'] = 'Bearer $bearerKey';
    dio.options.headers['Accept'] = 'application/json';

    Response response = await dio.get(
        'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US$pageNumber&primary_release_year=$releaseYear&sort_by=popularity.desc');

    int randomIndex = Random().nextInt(response.data['results'].length);
    Map<String, dynamic> randomMovie = response.data['results'][randomIndex];
    Map<String, dynamic> movieData = {
      'title': randomMovie['title'],
      'description': randomMovie['overview'],
      'release_year': randomMovie['release_date'].toString().substring(0, 4),
      'vote_average': randomMovie['vote_average'].toString(),
      'poster_path': 'https://image.tmdb.org/t/p/w600_and_h900_bestv2' +
          randomMovie['poster_path'],
    };
    print(movieData);
    return movieData;
  }
}

    




// class FilmApi {
//   final Dio dio;

//   FilmApi(this.dio);

//   Future<Map<String, dynamic>> getMovie() async {
//     dio.options.headers['Authorization'] =
//         'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZWQ2NjJiNzc1MTIxOThmZjBmZTIxNGQwN2ZlZDljNSIsInN1YiI6IjY1MjI2YzM5MDcyMTY2MDExYzA1YzdhNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.le_mcHwYS_PzUQADBaC_XQe0HrFbtTqChmv6J3El3UI';
//     dio.options.headers['Accept'] = 'application/json';

//     Response response = await dio.get(
//         'https://api.themoviedb.org/3/find/tt0468569?external_source=imdb_id');
//     //Debug print
//     print(response.data['movie_results'][0]['title']);
//     return {
//       'title': response.data['movie_results'][0]['title'],
//       'description': response.data['movie_results'][0]['overview'],
//     };
//   }
// }
