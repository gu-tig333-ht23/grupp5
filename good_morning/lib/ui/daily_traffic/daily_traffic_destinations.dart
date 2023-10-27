import 'package:flutter/material.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'package:good_morning/ui/daily_traffic/daily_traffic.ui.dart';
import 'package:good_morning/utils/daily_traffic/daily_traffic_provider.dart';
import 'package:provider/provider.dart';

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
      // ignore: sized_box_for_whitespace
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
            // ignore: use_build_context_synchronously
            await Provider.of<DailyTrafficProvider>(context, listen: false)
                .fetchDefaultTrafficSettings();
            // ignore: use_build_context_synchronously
            showInfoDialog(context);
          } else if (type == 'From:' && defaultOrCurrent == 'Current') {
            provider.setCurrentFrom(
                newDestination!.name!, newDestination.address);
            Navigator.pop(context);
          } else if (type == 'To:' && defaultOrCurrent == 'Default') {
            await provider.storeToDestination(
                newDestination!.name!, newDestination.address);
            // ignore: use_build_context_synchronously
            await Provider.of<DailyTrafficProvider>(context, listen: false)
                .fetchDefaultTrafficSettings();
            // ignore: use_build_context_synchronously
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
