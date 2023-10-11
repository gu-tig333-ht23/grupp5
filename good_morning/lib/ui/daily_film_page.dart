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
    getMovie(context, FilmApi(dio));
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
              movieProvider.movieDate,
              movieProvider.movieRating,
              () {},
            ),
          ],
        ),
      ),
    );
  }

  void getMovie(BuildContext context, FilmApi filmApi) async {
    try {
      Map<String, dynamic> movieData = await filmApi.getMovie();

      Provider.of<MovieProvider>(context, listen: false).setMovie(
        movieData['title'],
        movieData['description'],
        movieData['release_year'],
        movieData['vote_average'],
      );
    } catch (e) {
      print('Error fetching movie: $e');
    }
  }

  Widget buildFullCard(String title, String description, String date,
      String rating, Function onTapAction) {
    return Card(
      color: Theme.of(context).cardColor,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('''

Released in $date with a score of $rating

$description'''),
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
  String _movieDate = '';
  String _movieRating = '';

  String get movieTitle => _movieTitle;
  String get movieDescription => _movieDescription;
  String get movieDate => _movieDate;
  String get movieRating => _movieRating;

  void setMovie(String title, String description, String date, String rating) {
    _movieTitle = title;
    _movieDescription = description;
    _movieDate = date;
    _movieRating = rating;
    notifyListeners();
  }
}
