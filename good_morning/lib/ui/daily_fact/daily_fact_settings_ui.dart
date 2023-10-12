import 'package:flutter/material.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'package:good_morning/utils/daily_fact/daily_fact_category_item.dart';
import 'package:provider/provider.dart';
import 'package:good_morning/utils/daily_fact/daily_fact_provider.dart';

class DailyFactSettingsPage extends StatelessWidget {
  const DailyFactSettingsPage();

  @override
  Widget build(BuildContext context) {
    var categories = context.watch<DailyFactProvider>().categories;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Fact of the Day - Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8, left: 8, top: 3),
                    child:
                        Text('Your categories', style: TextStyle(fontSize: 20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      // lists all categories, both chosen and unchosen
                      children: categories.map((category) {
                        return FactCategoryItem(
                            category, true); //clickable icon buttons
                      }).toList(),
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
