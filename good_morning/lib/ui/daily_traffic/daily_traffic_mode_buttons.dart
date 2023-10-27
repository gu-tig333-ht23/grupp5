// Widgets for the transport mode buttons
import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_traffic/daily_traffic_provider.dart';
import 'package:provider/provider.dart';

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
