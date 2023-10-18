import 'package:flutter/material.dart';
import 'package:good_morning/ui/daily_film/daily_film_list.dart';
import 'package:provider/provider.dart';
import 'package:good_morning/utils/daily_film.dart';
import 'package:good_morning/ui/daily_film/daily_film_settings.dart';
import 'package:transparent_image/transparent_image.dart';

class DailyFilmPage extends StatefulWidget {
  final ThemeData theme;

  const DailyFilmPage({super.key, required this.theme});

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
    final movieStreamInfo = Provider.of<MovieProvider>(context).streamInfo;

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
            style: const TextStyle(fontWeight: FontWeight.bold),
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
              Consumer<MovieProvider>(
                builder: (context, movieProvider, child) {
                  List<Map<String, String>> streamInfo =
                      movieProvider.streamInfo;

                  if (streamInfo.isEmpty) {
                    return const Center(
                      child: Text('No streaming information available.'),
                    );
                  } else {
                    return ListTile(
                      title: const Text('Streaming Information'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: streamInfo.map((info) {
                          return Text(
                              '${info['service']}: ${info['streamingType']}');
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
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
                    title,
                    description,
                    date,
                    rating,
                    posterPath,
                    tmdbId,
                    movieStreamInfo);
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

    // ignore: use_build_context_synchronously
    Provider.of<MovieProvider>(context, listen: false).setMovie(
        movieData['title'],
        movieData['description'],
        movieData['release_year'],
        movieData['vote_average'],
        movieData['poster_path'],
        movieData['tmdb_id'],
        movieData['streamingInfo']);
  } catch (e) {
    print('Error fetching movie: $e');
  }
}
