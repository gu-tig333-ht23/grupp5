import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherPage extends StatelessWidget {

  // Funktion för att extrahera longitud och latitud för inmatad location
  Future<Map<String, double>> geocodeLocation(String location) async {
  final apiKey = 'API_KEY'; // Ersätt med riktig API nyckel
  final query = Uri.encodeComponent(location);
  final url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=$apiKey';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final results = data['results'][0]['geometry']['location'];
        final double lat = results['lat'];
        final double lng = results['lng'];
        return {'latitude': lat, 'longitude': lng};
      }
    }

    // Handle other errors, if needed
    return Future.error('Geocoding failed');
  } catch (e) {
    // Handle exceptions, e.g., network errors
    return Future.error(e.toString());
  }
}





  @override
  Widget build(BuildContext context) {
    final TextEditingController weatherLocationController =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Weather'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: Column(
              children: [
                Icon(
                  Icons.sunny,
                  size: 75,
                ),
                Text(
                  '10°C',
                  textScaleFactor: 4,
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Torsdag   ', textScaleFactor: 2),
                    Text('10°C'),
                  ],
                ),
                Icon(
                  Icons.sunny,
                ),
                Icon(Icons.arrow_forward)
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Fredag    ', textScaleFactor: 2),
                    Text('7°C'),
                  ],
                ),
                Icon(Icons.water_drop),
                Icon(Icons.arrow_forward)
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Lördag    ', textScaleFactor: 2),
                    Text('7°C'),
                  ],
                ),
                Icon(Icons.water_drop),
                Icon(Icons.arrow_forward)
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Söndag    ', textScaleFactor: 2),
                    Text('7°C'),
                  ],
                ),
                Icon(Icons.water_drop),
                Icon(Icons.arrow_forward)
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Måndag    ', textScaleFactor: 2),
                    Text('7°C'),
                  ],
                ),
                Icon(Icons.water_drop),
                Icon(Icons.arrow_forward)
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Tisdag    ', textScaleFactor: 2),
                    Text('7°C'),
                  ],
                ),
                Icon(Icons.water_drop),
                Icon(Icons.arrow_forward)
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Onsdag    ', textScaleFactor: 2),
                    Text('7°C'),
                  ],
                ),
                Icon(Icons.water_drop),
                Icon(Icons.arrow_forward)
              ],
            ),
          ),
          IconButton(
  iconSize: 50,
  onPressed: () async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change location'),
          content: TextField(
            controller: weatherLocationController,
            decoration: InputDecoration(hintText: 'Type your location'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Change'),
              onPressed: () async {
                final location = weatherLocationController.text;
                final coordinates = await geocodeLocation(location);
                if (coordinates != null) {
                  // Printa koordinater i konsol för att se att det funkar
                  print('Latitude: ${coordinates['latitude']}, Longitude: ${coordinates['longitude']}');
                } else {
                  print('Location not found.');
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  },
  icon: Icon(Icons.place),
)

        ],
      ),
    );
  }
}
