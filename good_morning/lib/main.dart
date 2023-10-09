import 'package:flutter/material.dart';
import '/ui/home_page.dart';
import '/ui/daily_film_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Good Morning',
        theme: lightTheme,
        darkTheme: darkTheme,
        home: HomePage(),
      ),
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
