import 'package:provider/provider.dart';
import '../common_ui.dart';
import 'package:flutter/material.dart';
import 'package:good_morning/ui/daily_history_ui.dart';
import 'package:good_morning/ui/daily_fact/daily_fact_ui.dart';
import '../weather_ui.dart';
import 'package:good_morning/ui/daily_film_page.dart';
import 'package:good_morning/ui/daily_traffic.ui.dart';

class HomePage extends StatelessWidget {
  final String factText;

  const HomePage({required this.factText, super.key});

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
              Consumer<VisibilityModel>(
                builder: (context, visibilityModel, child) => CheckboxListTile(
                  title: const Text('Show Traffic of the Day'),
                  value: visibilityModel.showTraffic,
                  onChanged: (bool? value) {
                    visibilityModel.toggleTraffic();
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
                buildFullCard(context,
                    title: 'Weather',
                    description: 'Show the weather', onTapAction: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => WeatherPage()));
                  print('Navigating to Weather Screen');
                }),
              if (visibilityModel.showTraffic)
                buildFullCard(context,
                    title: 'Traffic',
                    description:
                        'Little traffic, approximately 51 mins to work by bicycle.',
                    onTapAction: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DailyTrafficPage()));
                  print('Navigating to Traffic Information Screen');
                }),
              if (visibilityModel.showHistory)
                buildFullCard(context,
                    title: 'Today in History',
                    description: 'Today, Steve Jobs died 12 years ago.',
                    onTapAction: () {
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
                      child: buildFullCard(context,
                          title: 'Fact of the Day',
                          description: factText.trim(), onTapAction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DailyFactPage(factText: factText),
                          ),
                        );
                        print('Navigating to Fact of the Day Screen');
                      }),
                    ),
                  if (visibilityModel.showFilm)
                    Expanded(
                      child: buildFullCard(
                        context,
                        title: 'Film of the Day',
                        description: 'The Dark Knight',
                        onTapAction: () {
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
  bool _showTraffic = true;

  bool get showWeather => _showWeather;
  bool get showHistory => _showHistory;
  bool get showFact => _showFact;
  bool get showFilm => _showFilm;
  bool get showTraffic => _showTraffic;

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

  void toggleTraffic() {
    _showTraffic = !_showTraffic;
    notifyListeners();
  }
}
