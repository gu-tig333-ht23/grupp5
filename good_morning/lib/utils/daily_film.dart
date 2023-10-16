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

  String pageNumber = '&page=${Random().nextInt(10)}';

  Future<Map<String, dynamic>> getMovie() async {
    try {
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
      };
      print(movieData);
      return movieData;
    } catch (e) {
      if (e is DioException &&
          e.response != null &&
          e.response!.statusCode == 422) {
        print('Received a 422 error. Retrying...');
        return getMovie();
      } else {
        print('Error fetching movie: $e');
        rethrow;
      }
    }
  }
}
