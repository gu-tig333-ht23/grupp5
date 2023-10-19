import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String weatherAPIDayForecast =
    'https://api.open-meteo.com/v1/forecast?latitude=57.7072&longitude=11.9668&hourly=temperature_2m&timezone=Europe%2FBerlin&forecast_days=1';

String weatherAPICurrent =
    'https://api.open-meteo.com/v1/forecast?latitude=57.7072&longitude=11.9668&current=temperature_2m&timezone=Europe%2FBerlin&forecast_days=1';

Future<double> fetchCurrentTemperature() async {
  try {
    final response = await http.get(Uri.parse(weatherAPICurrent));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      double currentTemperature = jsonData['current']['temperature_2m'];
      return currentTemperature;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}

Future<List<double>> fetchDailyForecast() async {
  try {
    final response = await http.get(Uri.parse(weatherAPIDayForecast));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> temperatureData = jsonData['hourly']['temperature_2m'];
      List<double> temperaturesDay = temperatureData.cast<double>();
      return temperaturesDay; // Return the list of temperature values
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController weatherLocationController =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Weather'),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Change location'),
                          content: TextField(
                            controller: weatherLocationController,
                            //final coordinates = await geocodeLocation(location);
                            //if (coordinates != null) {
                            // Printa koordinater i konsol för att se att det funkar
                            //print('Latitude: ${coordinates['latitude']}, Longitude: ${coordinates['longitude']}');
                            //} else {
                            //print('Location not found.');
                            //}
                            decoration:
                                InputDecoration(hintText: 'Type your location'),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Change'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
                icon: Icon(Icons.place)),
          ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<double>(
              future: fetchCurrentTemperature(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  double currentTemp = snapshot.data ?? 0.0;
                  return Text(
                    '$currentTemp °C',
                    style: TextStyle(fontSize: 40),
                  );
                }
              },
            ),
            FutureBuilder<List<double>>(
              future: fetchDailyForecast(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<double> temperatures = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: temperatures.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${index}:00 ${temperatures[index]} °C'),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}



/* IconButton(
          iconSize: 50,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Change location'),
                    content: TextField(
                      controller: weatherLocationController,
                      decoration:
                          InputDecoration(hintText: 'Type your location'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Change'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          },
          icon: Icon(Icons.place)),*/