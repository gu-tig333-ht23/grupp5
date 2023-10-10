import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_fact/daily_fact_list.dart';
import '/ui/home_page.dart';
import 'package:provider/provider.dart';
import 'package:good_morning/ui/daily_film_page.dart';
import 'package:good_morning/utils/daily_history.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DailyFactList(),
        ),
        ChangeNotifierProvider(
          create: (context) => MovieProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HistoryProvider(),
        ),
      ],
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
      theme: lightTheme,
      darkTheme: darkTheme,
      home: HomePage(),
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
