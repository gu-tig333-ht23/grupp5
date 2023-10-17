import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_film.dart';
import 'package:good_morning/ui/daily_film/daily_film_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class DailyFilmSettingsProvider extends ChangeNotifier {
  String _releaseYear = '';

  String get releaseYear => _releaseYear;

  void setReleaseYear(String year) {
    _releaseYear = year;
    notifyListeners();
  }
}

class DailyFilmSettings extends StatelessWidget {
  final ThemeData theme;
  final TextEditingController yearController = TextEditingController();

  DailyFilmSettings({required this.theme});

  @override
  Widget build(BuildContext context) {
    var settingsModel = context.read<DailyFilmSettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Daily Film Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              getMovie(context, FilmApi(dio));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: const EdgeInsets.all(20.0),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: yearController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter desired release year",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FilledButton(
                onPressed: () {
                  settingsModel.setReleaseYear(yearController.text);
                  Navigator.pop(context);
                },
                child: const Text('Save settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
