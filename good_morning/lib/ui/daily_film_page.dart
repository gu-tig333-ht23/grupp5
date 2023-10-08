import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_film.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

final dio = Dio();

class DailyFilmPage extends StatefulWidget {
  final ThemeData theme;

  const DailyFilmPage({required this.theme});

  @override
  State<DailyFilmPage> createState() => DailyFilmPageState();
}

class DailyFilmPageState extends State<DailyFilmPage> {
  String movieTitle = '';
  String movieDescription = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Today's Film"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            buildFullCard(
              movieTitle,
              movieDescription,
              () async {
                await getMovie();
              },
            ),
          ],
        ),
      ),
    );
  }

  getMovie() async {
    dio.options.headers['Authorization'] =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZWQ2NjJiNzc1MTIxOThmZjBmZTIxNGQwN2ZlZDljNSIsInN1YiI6IjY1MjI2YzM5MDcyMTY2MDExYzA1YzdhNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.le_mcHwYS_PzUQADBaC_XQe0HrFbtTqChmv6J3El3UI';
    dio.options.headers['Accept'] = 'application/json';
    Response response;
    response = await dio.get(
        'https://api.themoviedb.org/3/find/tt0468569?external_source=imdb_id');

    setState(() {
      movieTitle = response.data['movie_results'][0]['title'];
      movieDescription = response.data['movie_results'][0]['overview'];
    });
  }

  Widget buildFullCard(String title, String description, Function onTapAction) {
    return Card(
      color: Theme.of(context).cardColor,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        onTap: () {
          onTapAction.call();
        },
      ),
    );
  }
}
