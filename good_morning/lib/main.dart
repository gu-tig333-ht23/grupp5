import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_fact/daily_fact_provider.dart';
import '/ui/home_page.dart';
import 'package:provider/provider.dart';
import 'package:good_morning/ui/daily_film_page.dart';

void main() async {
  // fetching the daily fact text
  var dailyFactProvider = DailyFactProvider();
  var chosenCats = dailyFactProvider.getChosenCategories();
  String factText = await fetchDailyFact(chosenCats);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => dailyFactProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => MovieProvider(),
        ),
        // other providers here..
      ],
      // sends the fact for the day as parameter
      child: MyApp(factText: factText),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String factText; // parameter

  const MyApp({Key? key, required this.factText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Good Morning',
      theme: lightTheme,
      darkTheme: darkTheme,
      // parameters sending forward to HomePage
      home: HomePage(factText: factText),
    );
  }
}

ThemeData lightTheme = ThemeData(
  primaryColor: Colors.yellow,
  colorScheme: const ColorScheme.light(
    primary: Colors.yellow,
  ),
  brightness: Brightness.light,
);

ThemeData darkTheme = ThemeData(
  primaryColor: Colors.deepOrange,
  colorScheme: const ColorScheme.dark(
    primary: Colors.deepOrange,
  ),
  brightness: Brightness.dark,
);
