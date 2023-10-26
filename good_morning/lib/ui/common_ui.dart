import 'package:flutter/material.dart';

Widget buildFullCard(BuildContext context,
    {String? title,
    String? description,
    Widget? optionalWidget,
    void Function()? onTapAction}) {
  return Card(
    color: Theme.of(context).cardColor,
    child: ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title,
              style: titleTextStyle,
            ),
          if (description != null) Text(description, style: bodyTextStyle),
          if (optionalWidget != null) optionalWidget,
        ],
      ),
      onTap: () {
        onTapAction?.call();
      },
    ),
  );
}

Widget buildFullCardWithImage(BuildContext context,
    {String? title,
    String? description,
    Widget? optionalWidget,
    String? imageUrl,
    void Function()? onTapAction}) {
  final decoration = imageUrl != null ? decorateImage(imageUrl) : null;

  return Card(
    color: Colors.transparent,
    child: Container(
      decoration: decoration,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: title != null ? Text(title, style: titleImageTextStyle) : null,
        subtitle: description != null
            ? Text(description, style: bodyImageTextStyle)
            : null,
        trailing: optionalWidget,
        onTap: () {
          onTapAction?.call();
        },
      ),
    ),
  );
}

Decoration? decorateImage(String imageUrl) {
  if (Uri.parse(imageUrl).isAbsolute) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black.withOpacity(1.0),
        ],
      ),
      image: DecorationImage(
        image: Image.network(imageUrl).image,
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
      ),
      borderRadius: BorderRadius.circular(8),
    );
  } else {
    return null;
  }
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    ),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

Widget buildFloatingActionButton(
  BuildContext context,
  IconData icon,
  void Function()? onPressed, {
  String? tooltip,
}) {
  return FloatingActionButton(
    onPressed: onPressed,
    tooltip: tooltip,
    backgroundColor: Theme.of(context).colorScheme.primary,
    child: Icon(icon),
  );
}

const TextStyle titleTextStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
);

const TextStyle subtitleTextStyle = TextStyle(
  fontSize: 18.0,
);

const TextStyle bodyTextStyle = TextStyle(
  fontSize: 16.0,
);

const TextStyle titleImageTextStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: [
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 5.0,
    ),
  ],
);

const TextStyle bodyImageTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.white,
  shadows: [
    Shadow(
      offset: Offset(0.0, 0.0),
      blurRadius: 5.0,
    ),
  ],
);
