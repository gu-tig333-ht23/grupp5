import 'package:flutter/material.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'package:provider/provider.dart';

class DailyTrafficProvider extends ChangeNotifier {
  final List<Destination> _savedDestinations = [
    Destination(name: 'Home', address: 'Parallellvägen 13E, 433 35 Partille'),
    Destination(name: 'Work', address: 'Medicinaregatan 15A, 413 90 Göteborg'),
    Destination(name: 'School', address: 'Skolvägen 12, 432 32 Jönköping'),
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
