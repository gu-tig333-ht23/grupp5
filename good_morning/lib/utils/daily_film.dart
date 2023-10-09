import 'package:dio/dio.dart';

const String apiKey = '28710339';
const String endPoint = 'http://www.omdbapi.com/?apikey=&';

final Dio dio = Dio();

class FilmApi {
  final Dio dio;

  FilmApi(this.dio);

  Future<Map<String, dynamic>> getMovie() async {
    dio.options.headers['Authorization'] =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZWQ2NjJiNzc1MTIxOThmZjBmZTIxNGQwN2ZlZDljNSIsInN1YiI6IjY1MjI2YzM5MDcyMTY2MDExYzA1YzdhNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.le_mcHwYS_PzUQADBaC_XQe0HrFbtTqChmv6J3El3UI';
    dio.options.headers['Accept'] = 'application/json';

    Response response = await dio.get(
        'https://api.themoviedb.org/3/find/tt0468569?external_source=imdb_id');
    print(response.data['movie_results'][0]['title']);
    return {
      'title': response.data['movie_results'][0]['title'],
      'description': response.data['movie_results'][0]['overview'],
    };
  }
}
