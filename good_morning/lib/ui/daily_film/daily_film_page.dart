import 'package:flutter/material.dart';
import 'package:good_morning/data_handling/film_data_storage.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'package:good_morning/ui/daily_film/daily_film_list.dart';
import 'package:provider/provider.dart';
import 'package:good_morning/utils/daily_film.dart';
import 'package:transparent_image/transparent_image.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class DailyFilmPage extends StatefulWidget {
  final ThemeData theme;

  const DailyFilmPage({super.key, required this.theme});

  @override
  State<DailyFilmPage> createState() => DailyFilmPageState();
}

class DailyFilmPageState extends State<DailyFilmPage> {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    final title = movieProvider.movieTitle;
    final description = movieProvider.movieDescription;
    final date = movieProvider.movieDate;
    final rating = movieProvider.movieRating;
    final posterPath = movieProvider.moviePosterPath;
    final tmdbId = movieProvider.movieId;
    final movieStreamInfo = movieProvider.streamInfo;
    final fetchDate = movieProvider.fetchDate;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Today's Film"),
        actions: [
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
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: posterPath,
                      imageScale: 1,
                      placeholderScale: 1),
                ),
              ),
              Card(
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Consumer<MovieProvider>(
                    builder: (context, movieProvider, child) {
                      List<Map<String, String>> streamInfo =
                          movieProvider.streamInfo;

                      if (streamInfo.isEmpty) {
                        return const Center(
                          child: Text('No streaming information available.'),
                        );
                      } else {
                        return ListTile(
                          title: const Text(
                              'Streaming information for Swedish providers'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: streamInfo.map((info) {
                              return Text(
                                  'Available on ${info['service']?.capitalize()}: ${info['streamingType']?.capitalize()}');
                            }).toList(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildSmallButton(
                  context,
                  'Fetch another movie',
                  () {
                    getMovie(context, FilmApi(dio), forceFetch: true);
                  },
                ),
              )
            ],
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              onPressed: () async {
                var outputText = await context
                    .read<FavoriteMoviesModel>()
                    .addFavorite(title, description, date, rating, posterPath,
                        tmdbId, movieStreamInfo, fetchDate);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(outputText as String),
                    action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          context.read<FavoriteMoviesModel>().removeMovie(
                              context
                                      .read<FavoriteMoviesModel>()
                                      .favoriteMovies
                                      .length -
                                  1);
                        }),
                  ),
                );
              },
              child: const Icon(Icons.favorite),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> getMovie(BuildContext context, FilmApi filmApi,
    {bool forceFetch = false}) async {
  final shouldFetch = forceFetch || await shouldFetchNewData();

  if (shouldFetch) {
    try {
      Map<String, dynamic> movieData = await filmApi.fetchMovie();

      Provider.of<MovieProvider>(context, listen: false).setMovie(
          movieData['title'],
          movieData['description'],
          movieData['release_year'],
          movieData['vote_average'],
          movieData['poster_path'],
          movieData['tmdb_id'],
          movieData['streamingInfo'],
          movieData['fetchDate']);
    } catch (e) {
      print('Error fetching movie: $e');
    }
  } else {
    final storedData = await getMovieData();
    if (storedData.isNotEmpty) {
      final List<Map<String, String>> streamInfo =
          (storedData['streamInfo'] as List<dynamic>)
              .cast<Map<String, String>>();

      Provider.of<MovieProvider>(context, listen: false).setMovie(
          storedData['movieTitle']!,
          storedData['movieDescription']!,
          storedData['movieDate']!,
          storedData['movieRating']!,
          storedData['moviePoster']!,
          storedData['movieId']!,
          streamInfo,
          storedData['fetchDate']!);
    }
  }
}
