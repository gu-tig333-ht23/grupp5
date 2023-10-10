import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:good_morning/utils/daily_film.dart';

class DailyFilmPage extends StatefulWidget {
  final ThemeData theme;

  const DailyFilmPage({required this.theme});

  @override
  State<DailyFilmPage> createState() => DailyFilmPageState();
}

class DailyFilmPageState extends State<DailyFilmPage> {
  @override
  void initState() {
    super.initState();
    getMovie(context);
  }

  @override
  Widget build(BuildContext context) {
    var movieProvider = Provider.of<MovieProvider>(context);

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
              movieProvider.movieTitle,
              movieProvider.movieDescription,
              () {},
            ),
          ],
        ),
      ),
    );
  }

  getMovie(BuildContext context) async {
    FilmApi filmApi = FilmApi(dio);
    Map<String, dynamic> movieData = await filmApi.getMovie();

    Provider.of<MovieProvider>(context, listen: false).setMovie(
      movieData['title'],
      movieData['description'],
    );
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

class MovieProvider with ChangeNotifier {
  String _movieTitle = '';
  String _movieDescription = '';

  String get movieTitle => _movieTitle;
  String get movieDescription => _movieDescription;

  void setMovie(String title, String description) {
    _movieTitle = title;
    _movieDescription = description;
    notifyListeners();
  }
}
