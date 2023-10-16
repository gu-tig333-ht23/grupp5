import 'package:provider/provider.dart';
import '../common_ui.dart';
import 'package:flutter/material.dart';
import 'package:good_morning/ui/daily_history_ui.dart';
import 'package:good_morning/ui/daily_fact/daily_fact_ui.dart';
import '../weather_ui.dart';
import 'package:good_morning/ui/daily_film_page.dart';

import 'filter_model.dart';
import 'onboarding.dart';

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
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<FilterModel>(
                builder: (context, visibilityModel, child) => CheckboxListTile(
                  title: const Text('Show Weather'),
                  value: visibilityModel.showWeather,
                  onChanged: (bool? value) {
                    visibilityModel.toggleWeather();
                  },
                ),
              ),
              Consumer<FilterModel>(
                builder: (context, visibilityModel, child) => CheckboxListTile(
                  title: const Text('Show History'),
                  value: visibilityModel.showHistory,
                  onChanged: (bool? value) {
                    visibilityModel.toggleHistory();
                  },
                ),
              ),
              Consumer<FilterModel>(
                builder: (context, visibilityModel, child) => CheckboxListTile(
                  title: const Text('Show Fact'),
                  value: visibilityModel.showFact,
                  onChanged: (bool? value) {
                    visibilityModel.toggleFact();
                  },
                ),
              ),
              Consumer<FilterModel>(
                builder: (context, visibilityModel, child) => CheckboxListTile(
                  title: const Text('Show Film'),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Good Morning', style: titleTextStyle),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<FilterModel>(
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
                          context, 'Fact of the Day', factText.trim(), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => DailyFactPage(
                                theme: Theme.of(context), factText: factText),
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
                        'The Dark Knight',
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
              buildBigButton(context, "Open onboarding", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OnBoardingScreen()),
                );
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
