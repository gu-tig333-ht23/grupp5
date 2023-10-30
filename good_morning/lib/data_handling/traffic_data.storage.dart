import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Persistent storage för Daily Traffic

// Setters

Future<void> storeDefaultFrom(String name, String address) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('defaultFromName', name);
    prefs.setString('defaultFromAddress', address);
  } catch (error) {
    if (kDebugMode) {
      print('Error storing defaultFrom: $error');
    }
  }
}

Future<void> storeDefaultTo(String name, String address) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('defaultToName', name);
    prefs.setString('defaultToAddress', address);
  } catch (error) {
    if (kDebugMode) {
      print('Error storing defaultTo: $error');
    }
  }
}

Future<void> storeDefaultTransportMode(String mode) async {
  try {
    if (mode.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('defaultMode', mode);
    }
  } catch (error) {
    if (kDebugMode) {
      print('Error storing defaultMode: $error');
    }
  }
}

Future<void> storeSavedDestinations(List<String> savedDestinations) async {
  try {
    if (savedDestinations.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('savedDestinations', savedDestinations);
    }
  } catch (error) {
    if (kDebugMode) {
      print('Error storing saved destinations: $error');
    }
  }
}

// adds new destination to the list with saved destinations
Future<void> addDestination(String name, String address) async {
  List<String> savedDestinations = await getStoredDestinations();
  // conjugates a string with both name and address separated by ':'
  savedDestinations.add('$name:$address');

  // Saves the updated list back to SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('savedDestinations', savedDestinations);
}

// removes destination from the list with saved destinations
Future<void> removeDestination(String name, String address) async {
  List<String> savedDestinations = await getStoredDestinations();

  savedDestinations.remove('$name:$address');

  // Saves the updated list back to SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('savedDestinations', savedDestinations);
}

// Getters
Future<Map<String, String>> getStoredDefaultFrom() async {
  final prefs = await SharedPreferences.getInstance();
  final defaultFromName = prefs.getString('defaultFromName');
  final defaultFromAddress = prefs.getString('defaultFromAddress');

  if (defaultFromAddress == null || defaultFromAddress.isEmpty) {
    return {
      'defaultFromName': 'Home',
      'defaultFromAddress': 'Parallellvägen 13E, 433 35 Partille',
    };
  } // else, user have stored defaultFrom

  return {
    'defaultFromName': defaultFromName ?? '',
    'defaultFromAddress': defaultFromAddress,
  };
}

Future<Map<String, String>> getStoredDefaultTo() async {
  final prefs = await SharedPreferences.getInstance();
  final defaultToName = prefs.getString('defaultToName');
  final defaultToAddress = prefs.getString('defaultToAddress');

  if (defaultToAddress == null || defaultToAddress.isEmpty) {
    return {
      'defaultToName': 'School',
      'defaultToAddress': 'Forskningsgången 6, 417 56 Göteborg',
    };
  } // else, user have stored defaultTo
  return {
    'defaultToName': defaultToName ?? '',
    'defaultToAddress': defaultToAddress,
  };
}

Future<String> getStoredDefaultMode() async {
  final prefs = await SharedPreferences.getInstance();
  final defaultMode = prefs.getString('defaultMode');
  if (defaultMode == null || defaultMode.isEmpty) {
    return 'Driving'; // default mode
  }
  return defaultMode;
}

Future<List<String>> getStoredDestinations() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final savedDestinations = prefs.getStringList('savedDestinations');

    return savedDestinations ?? [];
  } catch (error) {
    if (kDebugMode) {
      print('Error retrieving saved destinations: $error');
    }
    return [];
  }
}
