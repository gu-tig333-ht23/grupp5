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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: Card(
                        color: Theme.of(context).cardColor,
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: movieDetails[4],
                        ),
                      ),
                    ),
                    Consumer<FavoriteMoviesModel>(
                      builder: (context, favoriteMoviesModel, child) {
                        List<Map<String, String>> streamInfo =
                            formatMovieStreamInfo(movieDetails[6]);

                        if (streamInfo.isEmpty) {
                          return const Center(
                            child: Text('No streaming information available.'),
                          );
                        } else {
                          String formattedStreamInfo = '';
                          for (var info in streamInfo) {
                            formattedStreamInfo +=
                                'Available on ${info['service']?.capitalize()}: ${info['streamingType']?.capitalize()}\n';
                          }
                          return ListTile(
                            title: const Text(
                              'Streaming information for Swedish providers',
                            ),
                            subtitle: Text(formattedStreamInfo),
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
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
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox(
              child: Text('No movies found in your watchlist, go add some!'),
            );
          }
        },
      ),
    );
  }
}

List<Map<String, String>> formatMovieStreamInfo(String input) {
  List<Map<String, String>> list = [];
  final regex = RegExp(r'{(.*?)}');
  final matches = regex.allMatches(input);

  for (final match in matches) {
    final matchString = match.group(1);
    final keyValuePairs = matchString?.split(', ');
    final map = <String, String>{};

    for (final pair in keyValuePairs!) {
      final parts = pair.split(': ');
      if (parts.length == 2) {
        map[parts[0]] = parts[1];
      }
    }

    list.add(map);
  }

  return list;
}
