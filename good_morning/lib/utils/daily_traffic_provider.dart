// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:good_morning/data_handling/traffic_data.storage.dart';
import 'package:good_morning/ui/common_ui.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:good_morning/data_handling/secrets.dart' as config;

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

  // Variables for user`s position
  String _myLatitude = '';
  String _myLongitude = '';
  String get myLatitude => _myLatitude;
  String get myLongitude => _myLongitude;

  // gets user preferences from Daily Traffic persistent storage
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
    print('Stored default mode: $defaultModeName');
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

    // default to-destination
    Map<String, String> defaultTo = await getStoredDefaultTo();
    String defaultToName = defaultTo['defaultToName'] ?? '';
    String defaultToAddress = defaultTo['defaultToAddress'] ?? '';
    print(
        'Retrieved default to-destination from storage: $defaultToName, $defaultToAddress');
    _defaultTo = Destination(name: defaultToName, address: defaultToAddress);
    setCurrentTo(defaultToName, defaultToAddress);

    // default from-destination
    Map<String, String> defaultFrom = await getStoredDefaultFrom();
    String defaultFromName = defaultFrom['defaultFromName'] ?? '';
    String defaultFromAddress = defaultFrom['defaultFromAddress'] ?? '';
    if (defaultFromName == 'MyPosition') {
      await setMyPosition(); // uses geoLocator to set defaultFrom with user`s position
      _defaultFrom = Destination(name: 'My', address: 'Position');
    } else {
      print(
          'Retrieved default from-destination from storage: $defaultFromName, $defaultFromAddress');
      _defaultFrom =
          Destination(name: defaultFromName, address: defaultFromAddress);
      setCurrentFrom(defaultFromName, defaultFromAddress);

      notifyListeners();
    }
  }

  Future<void> fetchSavedDestinations() async {
    List<String> savedDestinations = await getStoredDestinations();
    print('Retrieved stored destinations: $savedDestinations');
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
    print('Stored default from-destination as MyPosition');
    notifyListeners();
  }

  // Retrieves the user`s position
  Future<void> setMyPosition() async {
    // get position using GeoLocator
    Map<String, String> positionMap = await determinePosition();

    String latitude = positionMap['latitude']!;
    String longitude = positionMap['longitude']!;

    _myLatitude = latitude;
    _myLongitude = longitude;
    // transforms into readable address
    String? address = await getAddressFromLatLng(latitude, longitude);
    if (address != null) {
      // transform went well
      setCurrentFrom(null, address);
      notifyListeners();
      print('Setting the current from-destination to $address');
    } else {
      // no address was returned, using lat/lng
      setCurrentFrom(null,
          '$latitude,$longitude'); // using position as current from-destination
      notifyListeners();
      print(
          'Setting the current from-destination to latitude $latitude and longitude $longitude');
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
      int index = savedDestinations.indexWhere((destination) =>
          destination.name == name || destination.name!.toLowerCase() == name);
      if (index != -1) {
        _currentFrom = savedDestinations.elementAt(index);
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
}

// Widgets for the transport mode buttons
class CarIconButton extends StatelessWidget {
  const CarIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    bool selected = context.watch<DailyTrafficProvider>().carIsSelected;

    return IconButton(
      icon: selected
          ? Icon(
              Icons.directions_car,
              size: 25,
              color: Theme.of(context).colorScheme.primary,
            )
          : const Icon(Icons.directions_car, size: 25),
      onPressed: () {
        Provider.of<DailyTrafficProvider>(context, listen: false)
            .setMode(TransportMode.driving);
        Provider.of<DailyTrafficProvider>(context, listen: false)
            .toggleCarButton();
      },
    );
  }
}

class BikeIconButton extends StatelessWidget {
  const BikeIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    bool selected = context.watch<DailyTrafficProvider>().bikeIsSelected;

    return IconButton(
      icon: selected
          ? Icon(
              Icons.directions_bike,
              size: 25,
              color: Theme.of(context).colorScheme.primary,
            )
          : const Icon(Icons.directions_bike, size: 25),
      onPressed: () {
        Provider.of<DailyTrafficProvider>(context, listen: false)
            .setMode(TransportMode.bicycling);
        Provider.of<DailyTrafficProvider>(context, listen: false)
            .toggleBikeButton();
      },
    );
  }
}

class WalkIconButton extends StatelessWidget {
  const WalkIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    bool selected = context.watch<DailyTrafficProvider>().walkIsSelected;

    return IconButton(
      icon: selected
          ? Icon(
              Icons.directions_walk,
              size: 25,
              color: Theme.of(context).colorScheme.primary,
            )
          : const Icon(Icons.directions_walk, size: 25),
      onPressed: () {
        Provider.of<DailyTrafficProvider>(context, listen: false)
            .setMode(TransportMode.walking);
        Provider.of<DailyTrafficProvider>(context, listen: false)
            .toggleWalkButton();
      },
    );
  }
}

class Destination {
  String? name;
  String address;

  Destination({this.name, required this.address});
}

// for showing from destinations in route
class DestinationItem extends StatelessWidget {
  final Destination destination;
  final String type;
  const DestinationItem(this.destination, this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textInputController = TextEditingController();

    void showDestinationInputDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(type),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                        controller: textInputController,
                        decoration: const InputDecoration(
                            labelText: 'Type your address:')),
                    const SizedBox(height: 8),
                    buildSmallButton(
                      context,
                      'Save',
                      () {
                        String destination = textInputController.text;
                        if (type == 'From:') {
                          Provider.of<DailyTrafficProvider>(context,
                                  listen: false)
                              .setCurrentFrom(null, destination);
                          Navigator.pop(context);
                        } else {
                          // the type is "To:"
                          Provider.of<DailyTrafficProvider>(context,
                                  listen: false)
                              .setCurrentTo(null, destination);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text('Or choose from your saved destinations:'),
                    DestinationDropdown(
                      type: type,
                      defaultOrCurrent: 'Current',
                      onInfoDialogClosed: () {
                        // does nothing, back to full screen
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ]);
          });
    }

    return Tooltip(
      message: destination.address,
      child: Container(
        width: 270,
        child: (destination.name != null)
            ? buildSmallButton(context, destination.name!, () {
                showDestinationInputDialog(context);
              })
            : buildSmallButton(context, destination.address, () {
                showDestinationInputDialog(context);
              }),
      ),
    );
  }
}

// for showing saved destination in list
class SavedDestinationItem extends StatelessWidget {
  final Destination destination;
  const SavedDestinationItem(this.destination, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ClipRect(
              child: TextButton(
                child: Text(destination.name!),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: ClipRect(
                child: TextButton(
                  child: Text(destination.address),
                  onPressed: () {},
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                processDeleteDestination(context, destination);
              },
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

class DestinationDropdown extends StatelessWidget {
  final String type;
  final String defaultOrCurrent;
  final Function() onInfoDialogClosed;

  const DestinationDropdown({
    super.key,
    required this.type,
    required this.defaultOrCurrent,
    required this.onInfoDialogClosed,
  });

  @override
  Widget build(BuildContext context) {
    void showInfoDialog(BuildContext context) {
      var defaultFrom = context.read<DailyTrafficProvider>().defaultFrom;
      var defaultTo = context.read<DailyTrafficProvider>().defaultTo;
      var defaultMode = context.read<DailyTrafficProvider>().defaultMode;

      // capitalizes the first letter in mode
      String mode = defaultMode.name.toString();
      String modeCapitalized = mode[0].toUpperCase() + mode.substring(1);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Your Default Settings Saved!'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Displays info about current saved default settings
                Text('Default From-Destination:',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                Text(
                  '${defaultFrom.name}, ${defaultFrom.address}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text('Default To-Destination:',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                Text('${defaultTo.name}, ${defaultTo.address}',
                    style: const TextStyle(fontSize: 14)),
                Text('Default Transport Mode:',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                Text(modeCapitalized, style: const TextStyle(fontSize: 14)),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.pop(context);
                  onInfoDialogClosed();
                },
              ),
            ],
          );
        },
      );
    }

    return Consumer<DailyTrafficProvider>(builder: (context, provider, child) {
      List<Destination> savedDestinations = provider.savedDestinations;

      return DropdownButton<Destination>(
        // no preselected value when editing current destinations since they can be any address that
        // does not exist in the saved destinations dropdown
        value: null,
        onChanged: (Destination? newDestination) async {
          if (type == 'From:' && defaultOrCurrent == 'Default') {
            await provider.storeFromDestination(
                newDestination!.name!, newDestination.address);
            await Provider.of<DailyTrafficProvider>(context, listen: false)
                .fetchDefaultTrafficSettings();
            showInfoDialog(context);
          } else if (type == 'From:' && defaultOrCurrent == 'Current') {
            provider.setCurrentFrom(
                newDestination!.name!, newDestination.address);
            Navigator.pop(context);
          } else if (type == 'To:' && defaultOrCurrent == 'Default') {
            await provider.storeToDestination(
                newDestination!.name!, newDestination.address);
            await Provider.of<DailyTrafficProvider>(context, listen: false)
                .fetchDefaultTrafficSettings();
            showInfoDialog(context);
          } else {
            // To: and Current
            provider.setCurrentTo(
                newDestination!.name!, newDestination.address);
            Navigator.pop(context);
          }
        },
        items: savedDestinations.map((destination) {
          return DropdownMenuItem<Destination>(
            value: destination,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(destination.name!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(destination.address, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}

Future<void> editDefaultSettingsDialog(BuildContext context) async {
  TransportMode mode =
      Provider.of<DailyTrafficProvider>(context, listen: false).defaultMode;

  // shows current default settings
  void showInfoDialog(BuildContext context) {
    var defaultFrom = context.read<DailyTrafficProvider>().defaultFrom;
    var defaultTo = context.read<DailyTrafficProvider>().defaultTo;
    var defaultMode = context.read<DailyTrafficProvider>().defaultMode;

    // capitalizes the first letter in mode
    String mode = defaultMode.name.toString();
    String modeCapitalized = mode[0].toUpperCase() + mode.substring(1);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your Default Settings Saved!'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Displays info about current saved default settings
              Text('Default From-Destination:', //
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              Text(
                '${defaultFrom.name}, ${defaultFrom.address}',
                style: const TextStyle(fontSize: 14),
              ),
              Text('Default To-Destination:',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              Text('${defaultTo.name}, ${defaultTo.address}',
                  style: const TextStyle(fontSize: 14)),
              Text('Default Transport Mode:',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              Text(modeCapitalized, style: const TextStyle(fontSize: 14)),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      var defaultFrom = context.read<DailyTrafficProvider>().defaultFrom;
      var defaultTo = context.read<DailyTrafficProvider>().defaultTo;

      return AlertDialog(
        title: const Text('Your Route Settings'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Pick from your saved destinations here!',
                style: TextStyle(fontSize: 14)),
            const SizedBox(height: 5),
            Row(
              children: [
                TextButton(
                  child: Text('Use my position as default'),
                  onPressed: () {
                    Provider.of<DailyTrafficProvider>(context, listen: false)
                        .setDefaultFromAsUserPosition();
                    showInfoDialog(context);
                  },
                ),
                Icon(Icons.my_location,
                    size: 12, color: Theme.of(context).primaryColor),
              ],
            ),
            Text(
                // shows current default destinations above the dropdown
                'Default From-Destination:',
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).primaryColor)),
            Text('(${defaultFrom.name}, ${defaultFrom.address})',
                style: TextStyle(fontSize: 11)),
            DestinationDropdown(
              type: 'From:',
              defaultOrCurrent: 'Default',
              onInfoDialogClosed: () {
                Navigator.of(context).pop();
              },
            ),
            Text('Default To-Destination:',
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).primaryColor)),
            Text('(${defaultTo.name}, ${defaultTo.address})',
                style: TextStyle(fontSize: 11)),
            DestinationDropdown(
              type: 'To:',
              defaultOrCurrent: 'Default',
              onInfoDialogClosed: () {
                Navigator.of(context).pop();
              },
            ),
            const Text('Default TransportMode:',
                style: TextStyle(fontSize: 12)),
            DropdownButton<TransportMode>(
              value: mode,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 20,
              elevation: 16,
              onChanged: (newMode) async {
                String modetext;
                switch (newMode) {
                  case TransportMode.driving:
                    modetext = 'Driving';
                    break;
                  case TransportMode.bicycling:
                    modetext = 'Bicycling';
                    break;
                  case TransportMode.walking:
                    modetext = 'Walking';
                    break;
                  default:
                    modetext = 'Driving';
                    break;
                }
                await Provider.of<DailyTrafficProvider>(context, listen: false)
                    .storeMode(modetext);
                await Provider.of<DailyTrafficProvider>(context, listen: false)
                    .fetchDefaultTrafficSettings(); // updates the value in dropdown menu
                showInfoDialog(context);
              },
              items: <TransportMode>[
                TransportMode.driving,
                TransportMode.bicycling,
                TransportMode.walking,
              ].map<DropdownMenuItem<TransportMode>>((TransportMode mode) {
                Icon icon;
                String text;
                switch (mode) {
                  case TransportMode.driving:
                    icon = const Icon(Icons.directions_car);
                    text = 'Driving';
                    break;
                  case TransportMode.bicycling:
                    icon = const Icon(Icons.directions_bike);
                    text = 'Bicycling';
                    break;
                  case TransportMode.walking:
                    icon = const Icon(Icons.directions_walk);
                    text = 'Walking';
                    break;
                }
                return DropdownMenuItem<TransportMode>(
                  value: mode,
                  child: Row(
                    children: <Widget>[
                      icon,
                      const SizedBox(width: 8),
                      Text(text),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Edit Saved Destinations'),
            onPressed: () {
              showSavedDestinations(context);
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showSavedDestinations(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Consumer<DailyTrafficProvider>(
        builder: (context, provider, child) {
          var savedDestinations = provider.savedDestinations;

          return AlertDialog(
            title: const Text('Saved Destinations'),
            content: Container(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: savedDestinations.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      SavedDestinationItem(savedDestinations[index]),
                      if (index < savedDestinations.length - 1) const Divider(),
                    ],
                  );
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Add New Destination'),
                onPressed: () {
                  addDestinationDialog(context);
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Back'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> addDestinationDialog(BuildContext context) async {
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController addressController = TextEditingController(text: '');

  // makes a list with all current destination names saved
  var savedDestinations =
      context.read<DailyTrafficProvider>().savedDestinations;
  List<String> destinationNames = savedDestinations
      .map((destination) => destination.name!.toLowerCase())
      .toList();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Save New Destination'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration:
                    const InputDecoration(labelText: 'Destination Name'),
              ),
              TextField(
                controller: addressController,
                decoration:
                    const InputDecoration(labelText: 'Destination Address'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () async {
              String newName = nameController.text;
              String newAddress = addressController.text;

              if (!destinationNames.contains(newName.toLowerCase())) {
                // the name does not already exist
                Provider.of<DailyTrafficProvider>(context, listen: false)
                    .addNewDestination(newName, newAddress);
                Navigator.of(context).pop();
              } else {
                // the name already exists in saved destinations
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Oops!'),
                      content: const SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'There is already a saved destination with this name!'),
                            Text('Try another name for this address.'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      );
    },
  );
}

Future<void> processDeleteDestination(
    BuildContext context, Destination destination) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Saved Destination?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              Provider.of<DailyTrafficProvider>(context, listen: false)
                  .deleteDestination(destination);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<Map<String, String>> determinePosition() async {
  Map<String, String> positionMap = {
    'latitude': 'N/A',
    'longitude': 'N/A',
  };
  try {
    // Get current position (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    positionMap['latitude'] = position.latitude.toString();
    positionMap['longitude'] = position.longitude.toString();
  } catch (error) {
    print('Error getting location: $error');
  }
  return positionMap;
}

// API call code here
const String mapApiKey = config.mapApiKey;

// Google Maps Geocoding API
Future<String?> getAddressFromLatLng(String latitude, String longitude) async {
  const String geoCodingURL =
      'https://maps.googleapis.com/maps/api/geocode/json';

  final response = await http.get(
      Uri.parse('$geoCodingURL?latlng=$latitude,$longitude&key=$mapApiKey'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    if (data['status'] == 'OK') {
      // Extract the formatted address from the response
      return data['results'][0]['formatted_address'];
    } else {
      // Handle API error if necessary
      print('Error: ${data['status']} - ${data['error_message']}');
      return null;
    }
  } else {
    // Handle HTTP error if necessary
    print('Error: ${response.statusCode}');
    return null;
  }
}

// Google Maps Directions API

Future<Map<String, dynamic>> getRouteInfoFromAPI(
    String toAddress, String fromAddress, String mode) async {
  String mapUrl;
  if (kIsWeb) {
    // for running in web browsers, sends request through proxy server https://cors-anywhere.herokuapp.com (click there for access first!)
    mapUrl =
        'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/directions/json';
  } else {
    // for running in emulators
    mapUrl = 'https://maps.googleapis.com/maps/api/directions/json';
  }
  http.Response response = await http.get(Uri.parse(
      '$mapUrl?mode=$mode&destination=$toAddress&origin=$fromAddress&language=en&key=$mapApiKey'));

  if (response.statusCode == 200) {
    // the server returned 200 OK response
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  } else {
    throw Exception('Failed to load route information');
  }
}

Future<Uint8List> getMapFromAPI(
    String toAddress, String fromAddress, String mode) async {
  String directionsUrl;
  String embedStaticUrl;

  if (kIsWeb) {
    // for running in web browsers, sends request through proxy server https://cors-anywhere.herokuapp.com (click there for access first!)
    directionsUrl =
        'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/directions/json';

    embedStaticUrl =
        'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/staticmap';
  } else {
    // for running in emulators, without proxy
    directionsUrl = 'https://maps.googleapis.com/maps/api/directions/json';
    embedStaticUrl = 'https://maps.googleapis.com/maps/api/staticmap';
  }
  String markers =
      'markers=color:red|label:A|$fromAddress&markers=color:blue|label:B|$toAddress';

  // gets the direction data from API, decodes and encodes
  http.Response directionsResponse = await http.get(Uri.parse(
      '$directionsUrl?mode=$mode&destination=$toAddress&origin=$fromAddress&alternatives=true&key=$mapApiKey'));
  if (directionsResponse.statusCode == 200) {
    // if OK
    Map<String, dynamic> data = json.decode(directionsResponse.body);
    String polylineCoordinates =
        data['routes'][0]['overview_polyline']['points'];

    // builds the path for the route line
    String path = '&path=color:0x0000ff|weight:5|enc:$polylineCoordinates';

    // builds the static map url with polyline and markers
    String mapUrl =
        '$embedStaticUrl?size=600x300&$markers$path&key=$mapApiKey&mode=$mode';

    // gets the static map with route line and markers from API
    http.Response mapResponse = await http.get(Uri.parse(mapUrl));

    if (mapResponse.statusCode == 200) {
      // OK Response
      return mapResponse.bodyBytes;
    } else {
      throw Exception('Failed to load map');
    }
  } else {
    throw Exception('Failed to fetch directions');
  }
}

class GoogleMapWidget extends StatelessWidget {
  final bool isClickable;
  final Future<Uint8List> mapImage;

  const GoogleMapWidget(
      {super.key, required this.mapImage, required this.isClickable});

  @override
  Widget build(BuildContext context) {
    String fromDest = Provider.of<DailyTrafficProvider>(context, listen: false)
        .currentTo
        .address;
    String toDest = Provider.of<DailyTrafficProvider>(context, listen: false)
        .currentFrom
        .address;
    String mode = Provider.of<DailyTrafficProvider>(context, listen: false)
        .mode
        .name
        .toString();

    String mapLinkUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$fromDest&destination=$toDest&travelmode=$mode';

    return FutureBuilder<Uint8List>(
      future: mapImage,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while waiting for the future to complete
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Show error message if future completes with an error
        } else if (snapshot.hasData) {
          // If the future completes successfully, display the map image

          return GestureDetector(
            onTap: () {
              if (isClickable) {
                _launchURL(mapLinkUrl);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            ),
          ); // Display the Uint8List image data
        } else {
          return const Text(
              'No data'); // Show a default message if there's no data
        }
      },
    );
  }

  _launchURL(String url) async {
    Uri uriLink = Uri.parse(url);
    if (await canLaunchUrl(uriLink)) {
      await launchUrl(uriLink);
    } else {
      throw 'Could not launch url';
    }
  }
}

class MapInfoWidget extends StatelessWidget {
  final Future<Map<String, dynamic>> routeInfo;

  const MapInfoWidget({super.key, required this.routeInfo});

  @override
  Widget build(BuildContext context) {
    var currentFrom = context.watch<DailyTrafficProvider>().currentFrom;
    var currentTo = context.watch<DailyTrafficProvider>().currentTo;
    var transportMode = context.watch<DailyTrafficProvider>().mode;

    return FutureBuilder<Map<String, dynamic>>(
        future: routeInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: $snapshot.error}');
          } else if (snapshot.hasData) {
            var routeInfo = snapshot.data!;
            var duration =
                routeInfo['routes'][0]['legs'][0]['duration']['text'];
            var distance =
                routeInfo['routes'][0]['legs'][0]['distance']['text'];
            String from = currentFrom.name != null
                ? currentFrom.name!.toLowerCase()
                : currentFrom.address;
            String to = currentTo.name != null
                ? currentTo.name!.toLowerCase()
                : currentTo.address;

            String routeInfoText =
                'Right now it is around $duration from $from to $to if ${transportMode.name.toString()}. The distance is $distance.';

            return Text(
              routeInfoText,
            );
          } else {
            return const Text('No data');
          }
        });
  }
}
