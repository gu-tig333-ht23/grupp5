import 'package:flutter/material.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'package:good_morning/utils/daily_film.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class DailyFilmList extends StatelessWidget {
  final ThemeData theme;

  const DailyFilmList({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = context.watch<FavoriteMoviesModel>().favoriteMovies;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('My Watchlist'),
      ),
      body: ListView.builder(
        itemCount: favoriteMovies.length,
        itemBuilder: (context, index) {
          if (favoriteMovies.isEmpty) {
            return const Center(
              child: Text('Your watchlist is empty.'),
            );
          }

          if (index >= 0 && index < favoriteMovies.length) {
            List<String> movieDetails = favoriteMovies[index];
            if (movieDetails.isEmpty) {
              return const SizedBox();
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text(
                    movieDetails[0],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Release Date: ${movieDetails[2]} \nRating: ${movieDetails[3]}',
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(movieDetails[1]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Card(
                        color: Theme.of(context).cardColor,
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: movieDetails[4],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: buildSmallButton(
                        context,
                        'Remove from watchlist',
                        () {
                          context
                              .read<FavoriteMoviesModel>()
                              .removeMovie(index);
                        },
                      ),
                    ),
                    Consumer<FavoriteMoviesModel>(
                      builder: (context, favoriteMoviesModel, child) {
                        String movieTitle = movieDetails[0];

                        List<Map<String, String>> streamInfo =
                            favoriteMoviesModel.getStreamInfo(movieTitle);

                        if (streamInfo.isEmpty) {
                          return const Center(
                            child: Text('No streaming information available.'),
                          );
                        } else {
                          return ListTile(
                            title: const Text(
                              'Streaming information for Swedish providers',
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: streamInfo.map((info) {
                                return Text(
                                  '${info['service']?.capitalize()}: ${info['streamingType']?.capitalize()}',
                                );
                              }).toList(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
