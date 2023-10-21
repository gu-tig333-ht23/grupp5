import 'package:flutter/material.dart';
import 'package:good_morning/data_handling/user_preferences.dart';
import 'package:good_morning/ui/daily_film/daily_film_settings.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'package:good_morning/ui/main_navigation/onboarding.dart';
import 'package:good_morning/utils/daily_fact/daily_fact_provider.dart';
import 'package:good_morning/utils/daily_film.dart';
import 'package:good_morning/utils/daily_traffic_provider.dart';
import '/ui/main_navigation/home_page.dart';
import 'package:provider/provider.dart';
import 'package:good_morning/utils/daily_history.dart';
import 'ui/main_navigation/filter_model.dart';

void main() async {
  // fetching the daily fact text
  //var dailyFactProvider = DailyFactProvider();
  //var chosenCats = dailyFactProvider.getChosenCategories();
  //String factText = (await fetchDailyFact(chosenCats)).trim();
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
          create: (context) => DailyFilmSettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FilterModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DailyTrafficProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteMoviesModel(),
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
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: FutureBuilder<bool>(
        future: isOnboardingCompleted(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return HomePage(factText: factText);
            } else {
              return const OnBoardingScreen();
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  return ThemeData(
    primaryColor: Colors.deepOrange,
    colorScheme: brightness == Brightness.light
        ? const ColorScheme.light(
            primary: Colors.deepOrange,
            secondary: Colors.deepOrange,
          )
        : const ColorScheme.dark(
            primary: Colors.deepOrange,
            secondary: Colors.deepOrange,
            background: Color(0xFF242424),
          ),
    brightness: brightness,
    textTheme: const TextTheme(
      displayLarge: titleTextStyle,
      titleMedium: subtitleTextStyle,
      bodyLarge: bodyTextStyle,
    ),
  );
}
