import 'package:flutter/material.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'package:good_morning/ui/daily_fact/daily_fact_settings_ui.dart';
import 'package:good_morning/utils/daily_fact/daily_fact_category_item.dart';
import 'package:good_morning/utils/daily_fact/daily_fact_provider.dart';
import 'package:provider/provider.dart';

class DailyFactPage extends StatelessWidget {
  final String factText;

  const DailyFactPage({super.key, required this.factText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Fact of the Day'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
        child: Column(
          children: [
            buildFullCard(context, description: factText.trim()),
            Card(
              color: Theme.of(context).cardColor,
              child: Column(
                children: [
                  const Text('Your categories', style: TextStyle(fontSize: 20)),
                  showChosenCategories(),
                  Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DailyFactSettingsPage(),
                          ),
                        );
                        print('Navigating to settings page for Daily Fact');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class showChosenCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var categories = context.watch<DailyFactProvider>().categories;

    return Column(
      children: categories.where((category) => category.chosen).map((category) {
        return FactCategoryItem(category, false); // not clickable
      }).toList(),
    );
  }
}
