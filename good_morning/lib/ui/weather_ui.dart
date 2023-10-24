import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherCard extends StatelessWidget {
  final String time;
  final double temperature;
  final double rain;
  final double snowfall;

  WeatherCard(
      {required this.time,
      required this.temperature,
      required this.rain,
      required this.snowfall});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(time, style: TextStyle(fontSize: 10)),
            SizedBox(height: 8),
            Text('$temperature°C', style: TextStyle(fontSize: 32)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$rain mm', style: TextStyle(fontSize: 12)),
                Icon(Icons.water_drop)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$snowfall cm', style: TextStyle(fontSize: 12)),
                Icon(Icons.ac_unit)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String weatherAPIDayForecast =
    'https://api.open-meteo.com/v1/forecast?latitude=57.7072&longitude=11.9668&current=temperature_2m,rain,snowfall&hourly=temperature_2m,rain,snowfall&timezone=Europe%2FBerlin&forecast_days=1';

String weatherAPICurrent =
    'https://api.open-meteo.com/v1/forecast?latitude=57.7072&longitude=11.9668&current=temperature_2m,rain,snowfall&hourly=temperature_2m,rain,snowfall&timezone=Europe%2FBerlin&forecast_days=1';

<<<<<<< Updated upstream
Future<double> fetchCurrentTemperature() async {
=======
Future<Map<String, dynamic>> fetchCurrentWeather() async {
>>>>>>> Stashed changes
  try {
    final response = await http.get(Uri.parse(weatherAPICurrent));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      Map<String, dynamic> currentWeather = jsonData['current'];
      return currentWeather;
    } else {
      throw Exception('Failed to load current weather data');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}

Future<List<Map<String, dynamic>>> fetchHourlyForecast() async {
  try {
    final response = await http.get(Uri.parse(weatherAPIDayForecast));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> hourlyData = jsonData['hourly']['time'];
      List<dynamic> temperatureData = jsonData['hourly']['temperature_2m'];
      List<dynamic> hourlyRain = jsonData['hourly']['rain'];
      List<dynamic> hourlySnow = jsonData['hourly']['snowfall'];

      List<Map<String, dynamic>> hourlyForecast = [];
      for (int i = 0; i < hourlyData.length; i++) {
        hourlyForecast.add({
          'time': hourlyData[i],
          'temperature_2m': temperatureData[i],
          'rain': hourlyRain[i],
          'snowfall': hourlySnow[i],
        });
      }

      return hourlyForecast;
    } else {
      throw Exception('Failed to load hourly forecast data');
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
<<<<<<< Updated upstream
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
=======
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
              icon: Icon(Icons.place))
        ],
      ),
>>>>>>> Stashed changes
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
<<<<<<< Updated upstream
            FutureBuilder<double>(
              future: fetchCurrentTemperature(),
=======
            FutureBuilder<Map<String, dynamic>>(
              future: fetchCurrentWeather(),
>>>>>>> Stashed changes
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  Map<String, dynamic> currentWeather = snapshot.data ?? {};
                  double currentTemp = currentWeather['temperature_2m'] ?? 0.0;
                  double currentRain = currentWeather['rain'] ?? 0.0;
                  double currentSnow = currentWeather['snowfall'] ?? 0.0;
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(height: 8),
                          Text(
                            '$currentTemp°C',
                            style: TextStyle(fontSize: 72),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('$currentRain mm',
                                  style: TextStyle(fontSize: 24)),
                              Icon(Icons.water_drop)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('$currentSnow cm',
                                  style: TextStyle(fontSize: 24)),
                              Icon(Icons.ac_unit)
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
<<<<<<< Updated upstream
            FutureBuilder<List<double>>(
              future: fetchDailyForecast(),
=======
            Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchHourlyForecast(),
>>>>>>> Stashed changes
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
<<<<<<< Updated upstream
                  List<double> temperatures = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: temperatures.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${index}:00 ${temperatures[index]} °C'),
=======
                  List<Map<String, dynamic>> hourlyForecast =
                      snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: hourlyForecast.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> hourData = hourlyForecast[index];
                      return WeatherCard(
                        time: hourData['time'],
                        temperature: hourData['temperature_2m'],
                        rain: hourData['rain'],
                        snowfall: hourData['snowfall'],
>>>>>>> Stashed changes
                      );
                    },
                  );
                }
              },
<<<<<<< Updated upstream
            ),
=======
            )),
>>>>>>> Stashed changes
          ],
        ),
      ),
    );
  }
}
