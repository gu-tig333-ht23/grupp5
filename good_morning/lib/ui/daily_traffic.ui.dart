import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_traffic/daily_traffic_api.dart';
import 'package:good_morning/utils/daily_traffic_provider.dart';
import 'package:provider/provider.dart';

import 'common_ui.dart';

class DailyTrafficPage extends StatelessWidget {
  final ThemeData theme;

  const DailyTrafficPage({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    var currentFrom = context.watch<DailyTrafficProvider>().currentFrom;
    var currentTo = context.watch<DailyTrafficProvider>().currentTo;
    var transportMode = context.watch<DailyTrafficProvider>().mode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Traffic Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Theme.of(context).cardColor,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () {
                            editDefaultSettingsDialog(context);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Your route ',
                                  style: TextStyle(
                                    fontSize: 22,
                                  )),
                              Icon(Icons.settings),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 20),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, bottom: 2),
                                        child: Row(
                                          children: [
                                            const Text('From:',
                                                style: TextStyle(fontSize: 15)),
                                            const SizedBox(width: 100),
                                            TextButton(
                                              child:
                                                  const Text('Use my position'),
                                              onPressed: () {
                                                Provider.of<DailyTrafficProvider>(
                                                        context,
                                                        listen: false)
                                                    .toggleUseMyPosition();
                                              },
                                            ),
                                            Icon(
                                              Icons.my_location,
                                              size: 15,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 2),
                                          child: DestinationItem(
                                              currentFrom, 'From:'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, bottom: 2),
                                        child: Text('To:',
                                            style: TextStyle(fontSize: 15)),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 2),
                                          child:
                                              DestinationItem(currentTo, 'To:'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(height: 30),
                              IconButton(
                                icon: const Icon(Icons.swap_vert, size: 40),
                                onPressed: () {
                                  Provider.of<DailyTrafficProvider>(context,
                                          listen: false)
                                      .swapDestinations(currentFrom, currentTo);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 8, top: 8),
                child: Row(
                  children: [
                    CarIconButton(),
                    BikeIconButton(),
                    WalkIconButton(),
                  ],
                ),
              ),
              Card(
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: Column(
                    children: [
                      GoogleMapWidget(
                          isClickable: true,
                          mapImage: getMapFromAPI(
                              currentTo.address,
                              currentFrom.address,
                              transportMode.name.toString())),
                      Text('For directions, tap the map'),
                      const SizedBox(height: 15),
                      MapInfoWidget(
                        routeInfo: getRouteInfoFromAPI(currentTo.address,
                            currentFrom.address, transportMode.name.toString()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                  child: const Text('Use my position as default'),
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
                style: const TextStyle(fontSize: 11)),
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
                style: const TextStyle(fontSize: 11)),
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
