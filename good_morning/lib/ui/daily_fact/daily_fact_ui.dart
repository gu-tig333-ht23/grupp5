import 'package:flutter/material.dart';
import 'package:good_morning/ui/daily_fact/daily_fact_settings_ui.dart';
import 'package:good_morning/utils/daily_fact/daily_fact_category_item.dart';
import 'package:good_morning/utils/daily_fact/daily_fact_provider.dart';
import 'package:provider/provider.dart';

class DailyFactPage extends StatelessWidget {
  final ThemeData theme;

  const DailyFactPage({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    var categories = context.watch<DailyFactProvider>().categories;

    // Extracts names of current chosen categories
    List<String> chosenCategories = categories
        .where((category) => category.chosen)
        .map((category) => category.categoryName)
        .toList();

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
                  FutureBuilder<String>(
                    future:
                        Provider.of<DailyFactProvider>(context, listen: false)
                            .fetchFactOfTheDay(chosenCategories),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.data == null) {
                        return const Text(
                            'No data available'); // handles null data case
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data!,

                            //'Lobsters do not age. They die from being caught by humans, from parasites, or from eating themselves to death.',
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
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
