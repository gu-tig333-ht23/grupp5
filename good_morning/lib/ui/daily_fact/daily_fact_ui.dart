import 'package:flutter/material.dart';
import 'package:good_morning/ui/daily_fact/daily_fact_settings_ui.dart';
import 'package:good_morning/utils/daily_fact/daily_fact.dart';
import 'package:good_morning/utils/daily_fact/daily_fact_list.dart';
import 'package:provider/provider.dart';

class DailyFactPage extends StatelessWidget {
  final ThemeData theme;

  const DailyFactPage({required this.theme});

  @override
  Widget build(BuildContext context) {
    var categories = context.watch<DailyFactList>().categories;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Good Morning'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 192, 187, 187),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8, left: 8, top: 8),
                    child: Text('Random Fact of the Day',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        //hårdkodad just nu, ska ha FactText sen
                        'Lobsters do not age. They die from being caught by humans, from parasites, or from eating themselves to death.',
                        style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 8.0, left: 8, top: 8, bottom: 20),
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFD95524),
                      foregroundColor: Colors.black),
                  onPressed: () {},
                  child: const Text('Next'),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 192, 187, 187),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8, left: 8, top: 8),
                    child: Text('Your categories',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      // lists only the current chosen categories
                      children: categories
                          .where((category) => category.chosen)
                          .map((category) {
                        return FactCategoryItem(
                            category, false); // not clickable
                      }).toList(),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DailyFactSettingsPage(theme: Theme.of(context)),
                          ),
                        );
                        print('Navigating to settings page for Daily Fact');
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
