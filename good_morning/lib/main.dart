import 'package:flutter/material.dart';
import 'package:good_morning/data_handling/user_preferences.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'package:good_morning/ui/main_navigation/onboarding.dart';
import 'package:good_morning/utils/daily_traffic/daily_fact_provider.dart';
import 'package:good_morning/utils/daily_film.dart';
import 'package:good_morning/utils/daily_traffic_provider.dart';
import 'package:good_morning/utils/weather.dart';
import '/ui/main_navigation/home_page.dart';
import 'package:provider/provider.dart';
import 'package:good_morning/utils/daily_history.dart';
import 'utils/filter_model.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DailyFactProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MovieProvider(),
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
        ChangeNotifierProvider(
          create: (context) => WeatherProvider(),
        )
      ],
      // sends the fact for the day as parameter to myApp
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
              return HomePage();
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
