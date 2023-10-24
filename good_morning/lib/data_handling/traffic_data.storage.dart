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

// Getters
Future<Map<String, String>> getStoredDefaultFrom() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final defaultFromName = prefs.getString('defaultFromName');
    final defaultFromAddress = prefs.getString('defaultFromAddress');
    print('Retrieving defaultFrom: $defaultFromName, $defaultFromAddress');

    return {
      'defaultFromName': defaultFromName ?? '',
      'defaultFromAddress': defaultFromAddress ?? '',
    };
  } catch (error) {
    print('Error retrieving defaultFrom: $error');
    return {
      'defaultFromName': '',
      'defaultFromAddress': '',
    };
  }
}

Future<Map<String, String>> getStoredDefaultTo() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final defaultToName = prefs.getString('defaultToName');
    final defaultToAddress = prefs.getString('defaultToAddress');
    print('Retrieving defaultTo: $defaultToName, $defaultToAddress');

    return {
      'defaultToName': defaultToName ?? '',
      'defaultToAddress': defaultToAddress ?? '',
    };
  } catch (error) {
    print('Error retrieving defaultTo: $error');
    return {
      'defaultToName': '',
      'defaultToAddress': '',
    };
  }
}

Future<String> getStoredDefaultMode() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final defaultMode = prefs.getString('defaultMode');
    print('Retrieving defaultMode: $defaultMode');

    return defaultMode ?? '';
  } catch (error) {
    print('Error retrieving defaultMode: $error');
    return '';
  }
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
