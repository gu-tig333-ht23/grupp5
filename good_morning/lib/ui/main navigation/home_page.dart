import 'package:good_morning/utils/daily_film.dart';
import 'package:provider/provider.dart';
import '../common_ui.dart';
import 'package:flutter/material.dart';
import 'package:good_morning/ui/daily_history_ui.dart';
import 'package:good_morning/ui/daily_fact/daily_fact_ui.dart';
import '../weather_ui.dart';
import 'package:good_morning/ui/daily_film/daily_film_page.dart';

class HomePage extends StatefulWidget {
  final String factText;

  HomePage({required this.factText, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var movieTitle;

  void initState() {
    super.initState();
    getMovie(context, FilmApi(dio));
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Filter Cards'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // makes the dialog more compact
            children: [
              Consumer<VisibilityModel>(
                builder: (context, visibilityModel, child) => CheckboxListTile(
                  title: const Text('Show Weather'),
                  value: visibilityModel.showWeather,
                  onChanged: (bool? value) {
                    visibilityModel.toggleWeather();
                  },
                ),
              ),
              Consumer<VisibilityModel>(
                builder: (context, visibilityModel, child) => CheckboxListTile(
                  title: const Text('Show History'),
                  value: visibilityModel.showHistory,
                  onChanged: (bool? value) {
                    visibilityModel.toggleHistory();
                  },
                ),
              ),
              Consumer<VisibilityModel>(
                builder: (context, visibilityModel, child) => CheckboxListTile(
                  title: const Text('Show Fact of the Day'),
                  value: visibilityModel.showFact,
                  onChanged: (bool? value) {
                    visibilityModel.toggleFact();
                  },
                ),
              ),
              Consumer<VisibilityModel>(
                builder: (context, visibilityModel, child) => CheckboxListTile(
                  title: const Text('Show Film of the Day'),
                  value: visibilityModel.showFilm,
                  onChanged: (bool? value) {
                    visibilityModel.toggleFilm();
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    movieTitle = Provider.of<MovieProvider>(context).movieTitle;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Good Morning'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<VisibilityModel>(
          builder: (context, visibilityModel, child) => ListView(
            children: [
              if (visibilityModel.showWeather)
                buildFullCard(context, 'Weather', 'Show the weather', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => WeatherPage()));
                  print('Navigating to Weather Screen');
                }),
              if (visibilityModel.showHistory)
                buildFullCard(context, 'Today in History',
                    'Today, Steve Jobs died 12 years ago.', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          DailyHistoryPage(theme: Theme.of(context)),
                    ),
                  );
                  print('Navigating to Today in History Screen');
                }),
              Row(
                children: [
                  if (visibilityModel.showFact)
                    Expanded(
                      child: buildFullCard(
                          context, 'Fact of the Day', widget.factText.trim(),
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => DailyFactPage(
                                theme: Theme.of(context),
                                factText: widget.factText),
                          ),
                        );
                        print('Navigating to Fact of the Day Screen');
                      }),
                    ),
                  if (visibilityModel.showFilm)
                    Expanded(
                      child: buildFullCard(
                        context,
                        'Film of the Day',
                        movieTitle,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DailyFilmPage(theme: Theme.of(context)),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16.0),
              buildSmallButton(context, "Small Button Test", () {
                print("Small Button Pressed!");
              }),
              const SizedBox(height: 16.0),
              buildBigButton(context, "Big Button Test", () {
                print("Big Button Pressed!");
              }),
              const SizedBox(height: 16.0),
              buildFloatingActionButton(
                context,
                Icons.add,
                () {
                  print("Floating Action Button Pressed!");
                },
                tooltip: 'Test',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VisibilityModel extends ChangeNotifier {
  bool _showWeather = true;
  bool _showHistory = true;
  bool _showFact = true;
  bool _showFilm = true;

  bool get showWeather => _showWeather;
  bool get showHistory => _showHistory;
  bool get showFact => _showFact;
  bool get showFilm => _showFilm;

  void toggleWeather() {
    _showWeather = !_showWeather;
    notifyListeners();
  }

  void toggleHistory() {
    _showHistory = !_showHistory;
    notifyListeners();
  }

  void toggleFact() {
    _showFact = !_showFact;
    notifyListeners();
  }

  void toggleFilm() {
    _showFilm = !_showFilm;
    notifyListeners();
  }
}
