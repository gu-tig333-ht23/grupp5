// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:good_morning/data_handling/film_data_storage.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'package:good_morning/ui/daily_film/daily_film_watchlist.dart';
import 'package:good_morning/utils/daily_film/daily_film_api.dart';
import 'package:good_morning/utils/daily_film/daily_film_model.dart';
import 'package:good_morning/utils/daily_film/daily_film_provider.dart';
import 'package:provider/provider.dart';
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
    Movie movie = context.watch<MovieProvider>().movie;

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
                        movie.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          'Released in ${movie.releaseYear} with a score of ${movie.rating}\n\n${movie.description}'),
                      onTap: () {}),
                ),
              ),
              Card(
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: movie.posterPath,
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
                      List<Map<String, String>> streamInfo = movie.streamInfo;

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
                var snackBarText = await context
                    .read<FavoriteMoviesModel>()
                    .addFavorite(movie);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(snackBarText[0]),
                    action: SnackBarAction(
                        label: snackBarText[1],
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
      final Movie movie = await filmApi.fetchMovie();

      Provider.of<MovieProvider>(context, listen: false).setMovie(movie);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching movie: $e');
      }
    }
  } else {
    final storedData = await getMovieData();
    if (storedData.isNotEmpty) {
      final List<Map<String, String>> streamInfo =
          (storedData['streamInfo'] as List<dynamic>)
              .cast<Map<String, String>>();

      final Movie movie = Movie(
        title: storedData['movieTitle']!,
        description: storedData['movieDescription']!,
        releaseYear: storedData['movieDate']!,
        rating: storedData['movieRating']!,
        posterPath: storedData['moviePoster']!,
        tmdbId: storedData['movieId']!,
        streamInfo: streamInfo,
        fetchDate: storedData['fetchDate']!,
      );

      Provider.of<MovieProvider>(context, listen: false).setMovie(movie);
    }
  }
}
