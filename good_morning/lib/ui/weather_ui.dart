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

  const WeatherCard({
    super.key,
    required this.time,
    required this.temperature,
    required this.rain,
    required this.snowfall,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(time, style: subtitleTextStyle),
            const SizedBox(height: 8),
            Text('$temperature°C', style: const TextStyle(fontSize: 32)),
            if (rain > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$rain mm', style: const TextStyle(fontSize: 12)),
                  const Icon(Icons.water_drop)
                ],
              ),
            if (snowfall > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$snowfall cm', style: const TextStyle(fontSize: 12)),
                  const Icon(Icons.ac_unit)
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  DateTime now = DateTime.now();
  late TextEditingController weatherLocationController;
  late String location = ''; // Add this line to store the location text

  @override
  void initState() {
    super.initState();
    weatherLocationController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Weather'),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Change location'),
                    content: TextField(
                      controller: weatherLocationController,
                      decoration:
                          const InputDecoration(hintText: 'Type your location'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Change'),
                        onPressed: () async {
                          location = weatherLocationController.text;
                          setState(() {
                            location = weatherLocationController.text;                            
                          });
                          await updateWeatherUrls(location);

                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.place),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: fetchCurrentWeather(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  Map<String, dynamic> currentWeather = snapshot.data ?? {};
                  double currentTemp = currentWeather['temperature_2m'] ?? 0.0;
                  double currentRain = currentWeather['rain'] ?? 0.0;
                  double currentSnow = currentWeather['snowfall'] ?? 0.0;
                  return Card(
                    elevation: 6,
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'Weather in $location',
                            style: subtitleTextStyle,
                          ),
                          Text(
                            '$currentTemp°C',
                            style: const TextStyle(fontSize: 72),
                          ),
                          if (currentRain > 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('$currentRain mm',
                                    style: const TextStyle(fontSize: 24)),
                                const Icon(Icons.water_drop)
                              ],
                            ),
                          if (currentSnow > 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('$currentSnow cm',
                                    style: const TextStyle(fontSize: 24)),
                                const Icon(Icons.ac_unit)
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
                  return const CircularProgressIndicator();
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

                      final hourTime = DateFormat("yyyy-MM-dd'T'HH:mm")
                          .parse(hourTimeString);

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
