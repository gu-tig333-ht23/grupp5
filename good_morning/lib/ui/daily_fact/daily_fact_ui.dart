import 'package:flutter/material.dart';
import 'package:good_morning/ui/daily_fact/daily_fact_settings_ui.dart';
import 'package:good_morning/utils/daily_fact/daily_fact_category_item.dart';
import 'package:good_morning/utils/daily_fact/daily_fact_provider.dart';
import 'package:provider/provider.dart';

class DailyFactPage extends StatelessWidget {
  final ThemeData theme;
  final String factText;

  const DailyFactPage({super.key, required this.theme, required this.factText});

  @override
  Widget build(BuildContext context) {
    // tracks the categories
    var categories = context.watch<DailyFactProvider>().categories;

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
                color: const Color.fromARGB(255, 255, 255, 255),
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
                    child: Text('Random Fact of the Day',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 3, left: 8.0, right: 8, bottom: 8),
                    child: Text(
                      factText.trim(), // the parameter displayed here
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
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
