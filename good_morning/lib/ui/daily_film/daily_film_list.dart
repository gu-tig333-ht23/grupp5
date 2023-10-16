import 'package:flutter/material.dart';
import 'package:good_morning/ui/daily_film/daily_film_page.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class DailyFilmList extends StatelessWidget {
  final ThemeData theme;

  DailyFilmList({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('My Watchlist'),
      ),
      body: ListView.builder(
        itemCount: context.watch<FavoriteMoviesModel>().favoriteMovies.length,
        itemBuilder: (context, index) {
          List<String> movieDetails =
              context.watch<FavoriteMoviesModel>().favoriteMovies[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ExpansionTile(
                title: Text(
                  movieDetails[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Release Date: ${movieDetails[2]} \nRating: ${movieDetails[3]}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
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
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<FavoriteMoviesModel>().removeMovie(index);
                      },
                      child: const Text('Remove from Watchlist'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
