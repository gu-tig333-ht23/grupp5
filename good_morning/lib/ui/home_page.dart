import 'common_ui.dart';
import 'package:flutter/material.dart';
import 'package:good_morning/ui/daily_history_ui.dart';
import 'package:good_morning/ui/daily_fact/daily_fact_ui.dart';
import 'package:good_morning/utils/weather.dart';
import 'package:good_morning/ui/daily_film_page.dart';

class HomePage extends StatelessWidget {
  final String factText;

  const HomePage({required this.factText, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Good Morning'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            buildFullCard(context, 'Weather', 'Show the weather', () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => WeatherPage()));
              print('Navigating to Weather Screen');
            }),
            buildFullCard(context, 'Today in History',
                'Today, Steve Jobs died 12 years ago.', () {
              // Add call to the Today in History screen
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
                Expanded(
                    child: buildHalfCard(
                        context, 'Fact of the Day', factText.trim(), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => DailyFactPage(
                          theme: Theme.of(context), factText: factText),
                    ),
                  );
                  print(
                      'Navigating to Fact of the Day Screen'); // control, can be removed later
                })),
                Expanded(
                  child: buildHalfCard(
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
    );
  }
