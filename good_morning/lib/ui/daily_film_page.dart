import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_film.dart';

class DailyFilmPage extends StatefulWidget {
  final ThemeData theme;

  const DailyFilmPage({required this.theme});

  @override
  State<DailyFilmPage> createState() => _DailyFilmPageState();
}

class _DailyFilmPageState extends State<DailyFilmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Today's Film"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildFullCard(
              'Daily Film Title',
              'Daily Film description',
              () {
                // Add call to the Weather screen
                print('movietime');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullCard(
      String title, String description, Function onTapAction) {
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
