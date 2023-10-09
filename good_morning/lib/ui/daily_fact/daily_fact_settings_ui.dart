import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_fact/daily_fact.dart';
import 'package:provider/provider.dart';
import 'package:good_morning/utils/daily_fact/daily_fact_list.dart';

class DailyFactSettingsPage extends StatelessWidget {
  final ThemeData theme;

  const DailyFactSettingsPage({required this.theme});

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
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8, left: 8, top: 8),
                    child: Text('Random Fact of the Day',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22)),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8, left: 8, top: 3),
                    child: Text('Your categories',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
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
                  onPressed: () {
                    Navigator.pop(context); // back to daily fact
                  },
                  child: const Text('Save'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
