import 'package:flutter/material.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'package:good_morning/utils/weather.dart';
import 'package:intl/intl.dart';


//Weather card
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
      elevation: 1,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(time, style: subtitleTextStyle),
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

class WeatherPage extends StatefulWidget {
  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  DateTime now = DateTime.now();

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
                            decoration:
                                InputDecoration(hintText: 'Type your location'),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Change'),
                              onPressed: () {
                                var location = weatherLocationController.text;
                                final coordinates = updateWeatherUrls(location);
                                if (coordinates != null) {
                                  // Printa koordinater i konsol för att se att det funkar
                                  //  print(
                                  //      'Latitude: ${coordinates['latitude']}, Longitude: ${coordinates['longitude']}');
                                } else {
                                  print('Location not found.');
                                }
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
            FutureBuilder<Map<String, dynamic>>(
              future: fetchCurrentWeather(context),
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
                    elevation: 6,
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(height: 8),
                          Text('Current local weather', style: subtitleTextStyle,),
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
            Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchHourlyForecast(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Map<String, dynamic>> hourlyForecast =
                      snapshot.data ?? [];

return ListView.builder(
  itemCount: hourlyForecast.length,
  itemBuilder: (context, index) {
    Map<String, dynamic> hourData = hourlyForecast[index];
    final hourTimeString = hourData['time'];
    final currentTime = DateTime.now();

    final hourTime = DateFormat("yyyy-MM-dd'T'HH:mm").parse(hourTimeString);

    if (hourTime.isAfter(currentTime)) {

      return WeatherCard(
        time: DateFormat.Hm().format(hourTime),
        temperature: hourData['temperature_2m'],
        rain: hourData['rain'],
        snowfall: hourData['snowfall'],
      );
    } else {
      return Container();
    }
                    },
                  );
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
