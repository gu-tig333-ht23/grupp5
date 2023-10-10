import 'package:flutter/material.dart';
import 'package:good_morning/ui/daily_fact_ui.dart';
import 'package:good_morning/ui/daily_fact/daily_fact_ui.dart';
import 'package:good_morning/utils/weather.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
            _buildFullCard('Weather', 'Show the weather', () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => WeatherPage()));
              print('Navigating to Weather Screen');
            }),
            _buildFullCard(
                'Today in History', 'Today, Steve Jobs died 12 years ago.', () {
              print('Navigating to Today in History Screen');
            }),
            Row(
              children: [
                Expanded(
                    child: _buildHalfCard('Fact of the Day',
                        'Lobsters do not age. They die from being caught by humans, from parasites, or from eating themselves to death.',
                        () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          DailyFactPage(theme: Theme.of(context)),
                    ),
                  );
                  print('Navigating to Fact of the Day Screen');
                })),
                Expanded(
                  child: _buildHalfCard(
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

  Widget _buildHalfCard(
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
