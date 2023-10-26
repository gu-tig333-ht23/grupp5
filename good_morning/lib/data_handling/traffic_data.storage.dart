import 'package:shared_preferences/shared_preferences.dart';

// Persistent storage för Daily Traffic

// Setters

Future<void> storeDefaultFrom(String name, String address) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('defaultFromName', name);
    prefs.setString('defaultFromAddress', address);
    print('Storing defaultFrom: $name, $address');
  } catch (error) {
    print('Error storing defaultFrom: $error');
  }
}

Future<void> storeDefaultTo(String name, String address) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('defaultToName', name);
    prefs.setString('defaultToAddress', address);
    print('Storing defaultTo: $name, $address');
  } catch (error) {
    print('Error storing defaultTo: $error');
  }
}

Future<void> storeDefaultTransportMode(String mode) async {
  try {
    if (mode.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('defaultMode', mode);
      print('Default transport mode stored: $mode');
    }
  } catch (error) {
    print('Error storing defaultMode: $error');
  }
}

Future<void> storeSavedDestinations(List<String> savedDestinations) async {
  try {
    if (savedDestinations.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('savedDestinations', savedDestinations);
      print('Saved destinations: $savedDestinations');
    }
  } catch (error) {
    print('Error storing saved destinations: $error');
  }
}

// adds new destination to the list with saved destinations
Future<void> addDestination(String name, String address) async {
  List<String> savedDestinations = await getStoredDestinations();
  // conjugates a string with both name and address separated by ':'
  savedDestinations.add('$name:$address');
  print('Adding destination $name,$address to storage list');

  // Saves the updated list back to SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('savedDestinations', savedDestinations);
}

// removes destination from the list with saved destinations
Future<void> removeDestination(String name, String address) async {
  List<String> savedDestinations = await getStoredDestinations();

  savedDestinations.remove('$name:$address');
  print('Removing destination $name,$address from storage list');

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
    print('Not stored yet, retrieving standard defaultFrom');
    return {
      'defaultFromName': 'Home',
      'defaultFromAddress': 'Parallellvägen 13E, 433 35 Partille',
    };
  } // else, user have stored defaultFrom
  print('Retrieving stored defaultFrom: $defaultFromName, $defaultFromAddress');
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
    print('Not stored yet, retrieving standard defaultTo');
    return {
      'defaultToName': 'School',
      'defaultToAddress': 'Forskningsgången 6, 417 56 Göteborg',
    };
  } // else, user have stored defaultTo
  print('Retrieving stored defaultTo: $defaultToName, $defaultToAddress');
  return {
    'defaultToName': defaultToName ?? '',
    'defaultToAddress': defaultToAddress,
  };
}

Future<String> getStoredDefaultMode() async {
  final prefs = await SharedPreferences.getInstance();
  final defaultMode = prefs.getString('defaultMode');
  if (defaultMode == null || defaultMode.isEmpty) {
    print('No default mode stored yet, returns standard mode');
    return 'Driving'; // default mode
  }
  print('Retrieving stored defaultMode: $defaultMode');
  return defaultMode;
}

Future<List<String>> getStoredDestinations() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final savedDestinations = prefs.getStringList('savedDestinations');
    print('Retrieving saved destinations list: $savedDestinations');

    return savedDestinations ?? [];
  } catch (error) {
    print('Error retrieving saved destinations: $error');
    return [];
  }
}
