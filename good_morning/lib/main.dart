import 'package:flutter/material.dart';
import 'package:good_morning/ui/daily_film_settings.dart';
import 'package:good_morning/utils/daily_fact/daily_fact_provider.dart';
import '/ui/main navigation/home_page.dart';
import 'package:provider/provider.dart';
import 'package:good_morning/ui/daily_film_page.dart';
import 'package:good_morning/utils/daily_history.dart';

void main() async {
  // fetching the daily fact text
  //var dailyFactProvider = DailyFactProvider();
  //var chosenCats = dailyFactProvider.getChosenCategories();
  //String factText = await fetchDailyFact(chosenCats);
  String factText =
      'Placeholder factText, in order to not use this API if not needed';
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DailyFactProvider(),
          //create: (context) => dailyFactProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => MovieProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DailyFilmSettingsModel(),
        ),
        // other providers here..
        ChangeNotifierProvider(
          create: (context) => HistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => VisibilityModel(),
        ),
      ],
      // sends the fact for the day as parameter to myApp
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
  primaryColor: Colors.deepOrange,
  colorScheme: const ColorScheme.light(
    primary: Colors.deepOrange,
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
