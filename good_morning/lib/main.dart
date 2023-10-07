import 'package:flutter/material.dart';
import '/ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
