import 'package:flutter/material.dart';
import 'package:good_morning/data_handling/traffic_data.storage.dart';
import 'package:good_morning/ui/daily_traffic/daily_traffic_destinations.dart';
import 'package:good_morning/utils/daily_traffic/daily_traffic_api.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

enum TransportMode { bicycling, walking, driving }

class DailyTrafficProvider extends ChangeNotifier {
  List<Destination> _savedDestinations = [];
  List<Destination> get savedDestinations => _savedDestinations;

  // Default route settings, to be updated from user preferences
  Destination _defaultFrom = Destination(name: '', address: '');
  Destination get defaultFrom => _defaultFrom;

  Destination _defaultTo = Destination(name: '', address: '');
  Destination get defaultTo => _defaultTo;

  TransportMode _defaultMode =
      TransportMode.driving; // default if not given any input yet
  TransportMode get defaultMode => _defaultMode;

  // default if none given yet
  Destination _currentFrom = Destination(name: '', address: '');
  // default if none given yet
  Destination _currentTo = Destination(name: '', address: '');

  Destination get currentFrom => _currentFrom;
  Destination get currentTo => _currentTo;

  TransportMode _selectedMode = TransportMode.driving;
  // driving by car as default

  TransportMode get mode => _selectedMode;

  // For the transportation mode buttons
  bool _carIsSelected = true; // default transportation mode
  bool get carIsSelected => _carIsSelected;

  bool _bikeIsSelected = false;
  bool get bikeIsSelected => _bikeIsSelected;

  bool _walkIsSelected = false;
  bool get walkIsSelected => _walkIsSelected;

  void toggleCarButton() {
    _carIsSelected = true;
    _bikeIsSelected = false;
    _walkIsSelected = false;
    notifyListeners();
  }

  void toggleBikeButton() {
    _carIsSelected = false;
    _bikeIsSelected = true;
    _walkIsSelected = false;
    notifyListeners();
  }

  void toggleWalkButton() {
    _carIsSelected = false;
    _bikeIsSelected = false;
    _walkIsSelected = true;
    notifyListeners();
  }

  // gets user preferences from Daily Traffic persistent storage when starting
  DailyTrafficProvider() {
    loadDefaultTrafficSettings();
  }

  Future<void> loadDefaultTrafficSettings() async {
    await fetchDefaultTrafficSettings();
    await fetchSavedDestinations();
  }

  Future<void> fetchDefaultTrafficSettings() async {
    // default transportation mode
    String defaultModeName = await getStoredDefaultMode();
    if (kDebugMode) {
      print('Stored default mode: $defaultModeName');
    }
    switch (defaultModeName) {
      case 'Driving':
        _defaultMode = TransportMode.driving;
        toggleCarButton();
        break;
      case 'Bicycling':
        _defaultMode = TransportMode.bicycling;
        toggleBikeButton();
        break;
      case 'Walking':
        _defaultMode = TransportMode.walking;
        toggleWalkButton();
        break;
      default:
        _defaultMode = TransportMode.driving;
        toggleCarButton();
        break;
    }
    _selectedMode = _defaultMode;

    // gets default to-destination
    Map<String, String> defaultTo = await getStoredDefaultTo();
    String defaultToName = defaultTo['defaultToName'] ?? '';
    String defaultToAddress = defaultTo['defaultToAddress'] ?? '';
    _defaultTo = Destination(name: defaultToName, address: defaultToAddress);
    setCurrentTo(defaultToName, defaultToAddress);

    // gets default from-destination
    Map<String, String> defaultFrom = await getStoredDefaultFrom();
    String defaultFromName = defaultFrom['defaultFromName'] ?? '';
    String defaultFromAddress = defaultFrom['defaultFromAddress'] ?? '';
    if (defaultFromName == 'MyPosition') {
      await setMyPosition(); // uses geoLocator to set defaultFrom with user`s position
      _defaultFrom = Destination(name: 'My', address: 'Position');
    } else {
      _defaultFrom =
          Destination(name: defaultFromName, address: defaultFromAddress);
      setCurrentFrom(defaultFromName, defaultFromAddress);

      notifyListeners();
    }
  }

  // gets the string list with saved destinations from storage
  Future<void> fetchSavedDestinations() async {
    List<String> savedDestinations = await getStoredDestinations();
    await storedDestinationsToItemList(savedDestinations);

    notifyListeners();
  }

  // transforms the string list to list with Destination items
  Future<void> storedDestinationsToItemList(List<String> storedStrings) async {
    List<Destination> fetchedDestinations = [];
    for (String dest in storedStrings) {
      List<String> nameAndAddress = dest.split(':');
      String name = nameAndAddress[0];
      String address = nameAndAddress[1];
      Destination destination = Destination(name: name, address: address);
      fetchedDestinations.add(destination);
    }
    _savedDestinations = fetchedDestinations;
    notifyListeners();
  }

  // function that sets the mode of transportation
  void setMode(TransportMode mode) {
    _selectedMode = mode;
    notifyListeners();
  }

  // function that activates geolocation
  void toggleUseMyPosition() async {
    await setMyPosition();
    notifyListeners();
  }

  void setDefaultFromAsUserPosition() {
    storeFromDestination('MyPosition', 'MyPosition');
    notifyListeners();
  }

  // Retrieves the user`s position
  Future<void> setMyPosition() async {
    // get position using GeoLocator
    Map<String, String> positionMap = await determinePosition();

    String latitude = positionMap['latitude']!;
    String longitude = positionMap['longitude']!;

    // transforms into readable address
    String? address = await getAddressFromLatLng(latitude, longitude);
    if (address != null) {
      // transform went well
      setCurrentFrom(null, address);
      notifyListeners();
    } else {
      // no address was returned, using lat/lng
      setCurrentFrom(null,
          '$latitude,$longitude'); // using position as current from-destination
      notifyListeners();
    }
  }

  // Stores default mode
  Future<void> storeMode(String mode) async {
    await storeDefaultTransportMode(mode);
    notifyListeners();
  }

  // Adds new destinations to the storage list of saved destinations
  Future<void> addNewDestination(String name, String address) async {
    await addDestination(name, address); // adds to storage
    savedDestinations.add(// adds to provider`s list, UI updates
        Destination(name: name, address: address));
    notifyListeners();
  }

  // Removes destination from the storage list
  Future<void> deleteDestination(Destination destination) async {
    await removeDestination(
        destination.name!, destination.address); // updates storage list
    savedDestinations.remove(destination); // provider`s list, UI updates
    notifyListeners();
  }

  // Stores the given destination as default From-destination
  Future<void> storeFromDestination(String name, String address) async {
    await storeDefaultFrom(name, address);
    notifyListeners();
  }

  // Stores the given destination as default To-destination
  Future<void> storeToDestination(String name, String address) async {
    await storeDefaultTo(name, address);
    notifyListeners();
  }

  // function that sets currentFrom for the API calls
  void setCurrentFrom(String? name, String address) {
    if (name != null) {
      // if name is provided
      int index = savedDestinations.indexWhere((destination) =>
          destination.name == name || destination.name!.toLowerCase() == name);
      // finds the corresponding element in the list with saved destinations
      if (index != -1) {
        // element is found
        _currentFrom = savedDestinations
            .elementAt(index); // sets this element to currentFrom
        notifyListeners();
      } else {
        // name is not null, but does not exist in savedDestinations
        Destination newDestination = Destination(name: name, address: address);
        _currentFrom = newDestination;
        notifyListeners();
      }
    } // if just address is provided
    else {
      Destination newFromDestination = Destination(address: address);
      _currentFrom = newFromDestination;
      notifyListeners();
    }
  }

  // Function that sets currentTo for the API calls
  void setCurrentTo(String? name, String address) {
    if (name != null) {
      int index = savedDestinations.indexWhere((destination) =>
          destination.name == name || destination.name!.toLowerCase() == name);
      if (index != -1) {
        _currentTo = savedDestinations.elementAt(index);
        notifyListeners();
      } else {
        // name is not null, but does not exist in savedDestinations
        Destination newDestination = Destination(name: name, address: address);
        _currentTo = newDestination;
        notifyListeners();
      }
    } // if just address is provided
    else {
      Destination newFromDestination = Destination(address: address);
      _currentTo = newFromDestination;
      notifyListeners();
    }
  }

  // function that swaps the to/from destinations
  void swapDestinations(
      Destination currentFromDest, Destination currentToDest) {
    setCurrentFrom(currentToDest.name, currentToDest.address);
    setCurrentTo(currentFromDest.name, currentFromDest.address);
  }
}

// checks whether the input is not empty, too long or contains special characters
bool isValidInput(String address) {
  RegExp specialCharRegex = RegExp(
      r'[!@#\$%^&*().?":{}|<>]'); // Define your set of special characters

  return (address.isNotEmpty &&
      address.length <= 50 &&
      !specialCharRegex.hasMatch(address));
}

// checks if the address is a valid location (Google Address Validation API)
Future<bool> isValidLocation(String address) async {
  return await isAddressValidLocation(address);
}

// Retrieves the user`s location
Future<Map<String, String>> determinePosition() async {
  Map<String, String> positionMap = {
    'latitude': 'N/A',
    'longitude': 'N/A',
  };
  // checks if the application has permission to use location
  // (If running in something that isn`t a web browser, web will get permission at its own before proceeding)
  if (!kIsWeb && !(await Permission.location.isGranted)) {
    var status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      // User denies the permission
      if (kDebugMode) {
        print('Location permission denied');
      }
      Map<String, String> defaultPos = {
        'latitude': '57.7065580',
        'longitude': '11.9366386',
      }; // default position, in order for the map to show anyway
      return defaultPos;
    }
  }

  try {
    // Get current position (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    positionMap['latitude'] = position.latitude.toString();
    positionMap['longitude'] = position.longitude.toString();
  } catch (error) {
    if (kDebugMode) {
      print('Error getting location: $error');
    }
  }
  return positionMap;
}
