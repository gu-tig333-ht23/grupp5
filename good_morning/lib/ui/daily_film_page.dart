import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:good_morning/utils/daily_film.dart';
import 'package:good_morning/ui/daily_film_settings.dart';
import 'package:transparent_image/transparent_image.dart';

class DailyFilmPage extends StatefulWidget {
  final ThemeData theme;

  const DailyFilmPage({required this.theme});

  @override
  State<DailyFilmPage> createState() => DailyFilmPageState();
}

class DailyFilmPageState extends State<DailyFilmPage> {
  @override
  @override
  Widget build(BuildContext context) {
    var settingsModel = context.watch<DailyFilmSettingsModel>();
    final title = Provider.of<MovieProvider>(context).movieTitle;
    final description = Provider.of<MovieProvider>(context).movieDescription;
    final date = Provider.of<MovieProvider>(context).movieDate;
    final rating = Provider.of<MovieProvider>(context).movieRating;
    final posterPath = Provider.of<MovieProvider>(context).moviePosterPath;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Today's Film"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DailyFilmSettings(theme: Theme.of(context)),
                ),
              );
            },
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Theme.of(context).cardColor,
              child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 16.0),
                  title: Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('''
      
Released in $date with a score of $rating

$description'''),
                  onTap: () {}),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Card(
              color: Theme.of(context).cardColor,
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: posterPath,
              ),
            ),
          )
        ],
      ),
    );
  }
}

void getMovie(BuildContext context, FilmApi filmApi) async {
  try {
    Map<String, dynamic> movieData = await filmApi.getMovie();

    Provider.of<MovieProvider>(context, listen: false).setMovie(
      movieData['title'],
      movieData['description'],
      movieData['release_year'],
      movieData['vote_average'],
      movieData['poster_path'],
    );
  } catch (e) {
    print('Error fetching movie: $e');
  }
}

class MovieProvider with ChangeNotifier {
  String _movieTitle = '';
  String _movieDescription = '';
  String _movieDate = '';
  String _movieRating = '';
  String _moviePosterPath = '';

  String get movieTitle => _movieTitle;
  String get movieDescription => _movieDescription;
  String get movieDate => _movieDate;
  String get movieRating => _movieRating;
  String get moviePosterPath => _moviePosterPath;

  void setMovie(String title, String description, String date, String rating,
      String posterPath) {
    _movieTitle = title;
    _movieDescription = description;
    _movieDate = date;
    _movieRating = rating;
    _moviePosterPath = posterPath;
    notifyListeners();
  }
}
