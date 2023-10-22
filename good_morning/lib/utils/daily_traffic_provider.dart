import 'package:flutter/material.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:typed_data';

import 'package:good_morning/data_handling/secrets.dart' as config;

enum TransportMode { bicycling, walking, driving, transit }

class DailyTrafficProvider extends ChangeNotifier {
  TransportMode _selectedMode =
      TransportMode.driving; // driving by car as default

  final List<Destination> _savedDestinations = [
    Destination(name: 'Home', address: 'Parallellvägen 13E, 433 35 Partille'),
    Destination(name: 'Work', address: 'Medicinaregatan 15A, 413 90 Göteborg'),
    Destination(name: 'School', address: 'Forskningsgången 6, 417 56 Göteborg'),
    Destination(name: 'The stable', address: 'Töpelsgatan 16, 416 55 Göteborg'),
    Destination(name: 'The gym', address: 'Klättercentret 31, 433 35 Partille')
  ];

  List<Destination> get savedDestinations => _savedDestinations;

  Destination _currentFrom =
      Destination(name: 'Home', address: 'Parallellvägen 13E, 433 35 Partille');

  Destination _currentTo = Destination(
      name: 'Work', address: 'Medicinaregatan 15A, 413 90 Göteborg');

  Destination get currentFrom => _currentFrom;
  Destination get currentTo => _currentTo;

  TransportMode get mode => _selectedMode;

  // function that sets the mode of transportation
  void setMode(TransportMode mode) {
    _selectedMode = mode;
    notifyListeners();
  }

  // function that sets currentFrom
  void setCurrentFrom(String name) {
    int index = savedDestinations.indexWhere((destination) =>
        destination.name == name || destination.name!.toLowerCase() == name);
    if (index != -1) {
      _currentFrom = savedDestinations.elementAt(index);
      notifyListeners();
    } // if not a saved destination
    else {
      Destination newFromDestination = Destination(address: name);
      _currentFrom = newFromDestination;
      notifyListeners();
    }
  }

  // function that sets currentTo
  void setCurrentTo(String name) {
    int index = savedDestinations.indexWhere((destination) =>
        destination.name == name || destination.name!.toLowerCase() == name);
    if (index != -1) {
      _currentTo = savedDestinations.elementAt(index);
      notifyListeners();
    } // if not a saved destination
    else {
      Destination newToDestination = Destination(address: name);
      _currentTo = newToDestination;
      notifyListeners();
    }
  }

  // function that saves destinations
  void saveDestination(String name, String address) {
    int index =
        savedDestinations.indexWhere((destination) => destination.name == name);
    if (index != -1) {
      // the destination name exists
      setAddress(index, address);
    } else {
      // save a new destination
      final newDestination = Destination(name: name, address: address);
      savedDestinations.add(newDestination);
      notifyListeners();
    }
  }

  Future<void> addNewDestination(String name, String address) async {
    Destination newDestination = Destination(name: name, address: address);
    savedDestinations.add(newDestination);
    notifyListeners();
  }

  Future<void> editDestinationName(
      Destination destination, String newName) async {
    destination.name = newName;
    notifyListeners();
  }

  Future<void> editDestinationAddress(
      Destination destination, String newAddress) async {
    destination.address = newAddress;
    notifyListeners();
  }

  Future<void> deleteDestination(Destination destination) async {
    savedDestinations.remove(destination);
    notifyListeners();
  }

// function that sets the address for existing destination by its name
  void setAddress(int index, String address) {
    Destination destination = savedDestinations.elementAt(index);
    destination.address = address;
    notifyListeners();
  }
}

class TransportationModeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mode = context.watch<DailyTrafficProvider>().mode;

    Icon getIconForMode() {
      switch (mode) {
        case TransportMode.driving:
          return Icon(Icons.directions_car, size: 50);
        case TransportMode.bicycling:
          return Icon(Icons.directions_bike, size: 50);
        case TransportMode.walking:
          return Icon(Icons.directions_walk, size: 50);
        case TransportMode.transit:
          return Icon(Icons.directions_bus, size: 50);
        default:
          return Icon(Icons.directions_car, size: 50);
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PopupMenuButton<TransportMode>(
              tooltip: 'Change Transportation Mode',
              icon: getIconForMode(),
              onSelected: (TransportMode mode) {
                Provider.of<DailyTrafficProvider>(context, listen: false)
                    .setMode(mode);
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<TransportMode>>[
                    const PopupMenuItem<TransportMode>(
                      value: TransportMode.driving,
                      child: Icon(Icons.directions_car),
                    ),
                    const PopupMenuItem<TransportMode>(
                      value: TransportMode.bicycling,
                      child: Icon(Icons.directions_bike),
                    ),
                    const PopupMenuItem<TransportMode>(
                      value: TransportMode.walking,
                      child: Icon(Icons.directions_walk),
                    ),
                    const PopupMenuItem<TransportMode>(
                      value: TransportMode.transit,
                      child: Icon(Icons.directions_bus),
                    ),
                  ]),
        )
      ],
    );
  }
}

void editModeDialog(context, mode) {}

class Destination {
  String? name;
  String address;

  Destination({this.name, required this.address});
}

// for showing from/to destinations in route
class DestinationItem extends StatelessWidget {
  final Destination destination;
  DestinationItem(this.destination);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: destination.address,
      child: (destination.name != null)
          ? buildSmallButton(context, destination.name!, () {})
          : buildSmallButton(context, destination.address, () {}),
    );
  }
}

// for showing saved destination in list
class SavedDestinationItem extends StatelessWidget {
  final Destination destination;
  SavedDestinationItem(this.destination);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ClipRect(
              child: TextButton(
                child: Text(destination.name!),
                onPressed: () {
                  editSavedName(context, destination);
                },
              ),
            ),
            Expanded(
              child: ClipRect(
                child: TextButton(
                  child: Text(destination.address),
                  onPressed: () {
                    editSavedAddress(context, destination);
                  },
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                processDeleteDestination(context, destination);
              },
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}

Future<void> editRouteDialog(BuildContext context) async {
  TextEditingController fromDestinationController = TextEditingController(
      text: context.read<DailyTrafficProvider>().currentFrom.name ??
          context.read<DailyTrafficProvider>().currentFrom.address);
  TextEditingController toDestinationController = TextEditingController(
      text: context.read<DailyTrafficProvider>().currentTo.name ??
          context.read<DailyTrafficProvider>().currentTo.address);

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Your Route'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                style: TextStyle(fontSize: 16),
                controller: fromDestinationController,
                decoration: InputDecoration(
                  labelText: 'From:',
                ),
              ),
              TextField(
                style: TextStyle(fontSize: 16),
                controller: toDestinationController,
                decoration: InputDecoration(
                  labelText: 'To:',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Saved Destinations'),
            onPressed: () {
              showSavedDestinations(context);
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              // logic to save edited destinations
              Provider.of<DailyTrafficProvider>(context, listen: false)
                  .setCurrentFrom(fromDestinationController.text);

              Provider.of<DailyTrafficProvider>(context, listen: false)
                  .setCurrentTo(toDestinationController.text);

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
            title: Text('Saved Destinations'),
            content: SingleChildScrollView(
              child: Column(
                children: savedDestinations.map((destination) {
                  return SavedDestinationItem(destination);
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Add New Destination'),
                onPressed: () {
                  addDestinationDialog(context);
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Back'),
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

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Save New Destination'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Destination Name'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Destination Address'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              String newName = nameController.text;
              String newAddress = addressController.text;

              Provider.of<DailyTrafficProvider>(context, listen: false)
                  .addNewDestination(newName, newAddress);

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> editSavedName(
    BuildContext context, Destination destination) async {
  TextEditingController nameController =
      TextEditingController(text: destination.name);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Destination Name'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Destination Name'),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              String newName = nameController.text;
              Provider.of<DailyTrafficProvider>(context, listen: false)
                  .editDestinationName(destination, newName);

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> editSavedAddress(
    BuildContext context, Destination destination) async {
  TextEditingController addressController =
      TextEditingController(text: destination.address);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Destination Address'),
        content: TextField(
          controller: addressController,
          decoration: InputDecoration(labelText: 'Destination Address'),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              String newAddress = addressController.text;
              Provider.of<DailyTrafficProvider>(context, listen: false)
                  .editDestinationAddress(destination, newAddress);

              Navigator.of(context).pop();
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
        title: Text('Delete Saved Destination?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Delete'),
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
// API code here

// Google Maps Directions API
const String mapApiKey = config.mapApiKey;

Future<Map<String, dynamic>> getRouteInfoFromAPI(
    String toName, String fromName, String mode) async {
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
      '$mapUrl?mode=$mode&destination=$toName&origin=$fromName&key=$mapApiKey'));

  if (response.statusCode == 200) {
    // the server returned 200 OK response
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  } else {
    throw Exception('Failed to load route information');
  }
}

Future<Uint8List> getMapFromAPI(
    String toName, String fromName, String mode) async {
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
      'markers=color:red|label:A|$fromName&markers=color:blue|label:B|$toName';

  // gets the direction data from API, decodes and encodes
  http.Response directionsResponse = await http.get(Uri.parse(
      '$directionsUrl?mode=$mode&destination=$toName&origin=$fromName&alternatives=true&key=$mapApiKey'));
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
  final Future<Uint8List> mapImage;

  GoogleMapWidget({required this.mapImage});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: mapImage,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while waiting for the future to complete
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Show error message if future completes with an error
        } else if (snapshot.hasData) {
          // If the future completes successfully, display the map image
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
            ),
          ); // Display the Uint8List image data
        } else {
          return Text('No data'); // Show a default message if there's no data
        }
      },
    );
  }
}

class MapInfoWidget extends StatelessWidget {
  final Future<Map<String, dynamic>> routeInfo;

  MapInfoWidget({required this.routeInfo});

  @override
  Widget build(BuildContext context) {
    var currentFrom = context.watch<DailyTrafficProvider>().currentFrom;
    var currentTo = context.watch<DailyTrafficProvider>().currentTo;
    var transportMode = context.watch<DailyTrafficProvider>().mode;

    return FutureBuilder<Map<String, dynamic>>(
        future: routeInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
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
                'Right now it is approximately $duration from $from to $to if ${transportMode.name.toString()}. The distance is $distance.';

            return Text(routeInfoText);
          } else {
            return Text('No data');
          }
        });
  }
}
