import 'package:flutter/material.dart';

Widget buildFullCard(BuildContext context, String title, String description,
    void Function()? onTapAction) {
  return Card(
    color: Theme.of(context).cardColor,
    child: ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(description),
      onTap: () {
        onTapAction?.call();
      },
    ),
  );
}

Widget buildHalfCard(BuildContext context, String title, String description,
    void Function()? onTapAction) {
  return Card(
    color: Theme.of(context).cardColor,
    child: ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(description),
      onTap: () {
        onTapAction?.call();
      },
    ),
  );
}

Widget buildSmallButton(
    BuildContext context, String label, void Function()? onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
    ),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

Widget buildBigButton(
    BuildContext context, String label, void Function()? onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
    ),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

Widget buildFloatingActionButton(
  BuildContext context,
  IconData icon,
  void Function()? onPressed, {
  Color? backgroundColor,
  String? tooltip,
}) {
  return FloatingActionButton(
    onPressed: onPressed,
    backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
    tooltip: tooltip,
    child: Icon(icon),
  );
}
