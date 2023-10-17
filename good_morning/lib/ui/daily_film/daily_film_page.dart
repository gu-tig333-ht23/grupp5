import 'package:flutter/material.dart';
import 'package:good_morning/ui/daily_film/daily_film_list.dart';
import 'package:provider/provider.dart';
import 'package:good_morning/utils/daily_film.dart';
import 'package:good_morning/ui/daily_film/daily_film_settings.dart';
import 'package:transparent_image/transparent_image.dart';

class DailyFilmPage extends StatefulWidget {
  final ThemeData theme;

  const DailyFilmPage({required this.theme});

  @override
  State<DailyFilmPage> createState() => DailyFilmPageState();
}

class DailyFilmPageState extends State<DailyFilmPage> {
  @override
  Widget build(BuildContext context) {
    final title = Provider.of<MovieProvider>(context).movieTitle;
    final description = Provider.of<MovieProvider>(context).movieDescription;
    final date = Provider.of<MovieProvider>(context).movieDate;
    final rating = Provider.of<MovieProvider>(context).movieRating;
    final posterPath = Provider.of<MovieProvider>(context).moviePosterPath;
    final tmdbId = Provider.of<MovieProvider>(context).movieId;

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
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DailyFilmList(theme: Theme.of(context)),
                ),
              );
            },
          ),
          Text(
            context
                .watch<FavoriteMoviesModel>()
                .favoriteMovies
                .length
                .toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 16.0),
                      title: Text(
                        title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          'Released in $date with a score of $rating\n\n$description'),
                      onTap: () {}),
                ),
              ),
              Card(
                color: Theme.of(context).cardColor,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: posterPath,
                ),
              ),
              // FutureBuilder<List<Map<String, String>>>(
              //   future: fetchStreamInfo(tmdbId),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     } else if (snapshot.hasError) {
              //       return Center(
              //         child: Text('Error: ${snapshot.error}'),
              //       );
              //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //       return Center(
              //         child: Text('No streaming information available.'),
              //       );
              //     } else {
              //       return ListTile(
              //         title: Text('Streaming Information'),
              //         subtitle: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: snapshot.data!.map((info) {
              //             return Text(
              //                 '${info['service']}: ${info['streamingType']}');
              //           }).toList(),
              //         ),
              //       );
              //     }
              //   },
              // )
            ],
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              onPressed: () async {
                context.read<FavoriteMoviesModel>().addFavorite(
                    title, description, date, rating, posterPath, tmdbId);
              },
              child: const Icon(Icons.favorite),
            ),
          ),
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
      movieData['tmdb_id'],
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
  String _movieId = '';

  String get movieTitle => _movieTitle;
  String get movieDescription => _movieDescription;
  String get movieDate => _movieDate;
  String get movieRating => _movieRating;
  String get moviePosterPath => _moviePosterPath;
  String get movieId => _movieId;

  void setMovie(String title, String description, String date, String rating,
      String posterPath, String id) {
    _movieTitle = title;
    _movieDescription = description;
    _movieDate = date;
    _movieRating = rating;
    _moviePosterPath = posterPath;
    _movieId = id;
    notifyListeners();
  }
}

class FavoriteMoviesModel extends ChangeNotifier {
  List<List<String>> _favoriteMovies = [];

  List<List<String>> get favoriteMovies => _favoriteMovies;

  Future<void> addFavorite(
    String movieTitle,
    String movieDescription,
    String movieDate,
    String movieRating,
    String moviePosterPath,
    String tmdbId,
  ) async {
    if (_favoriteMovies.any((movie) => movie[0] == movieTitle)) {
      print('Movie already in favorites');
    } else {
      print('Movie added to favorites');
      List<String> favoriteMovie = [
        movieTitle,
        movieDescription,
        movieDate,
        movieRating,
        moviePosterPath,
        tmdbId,
      ];
      _favoriteMovies.add(favoriteMovie);
    }
    notifyListeners();
  }

  void removeMovie(int index) {
    _favoriteMovies.removeAt(index);
    notifyListeners();
  }
}
