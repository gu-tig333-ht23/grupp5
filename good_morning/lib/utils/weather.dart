import 'package:flutter/material.dart';

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Weather'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(80),
        child: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Text(
                    '10°C',
                    textScaleFactor: 4,
                  ),
                  Icon(
                    Icons.sunny,
                    size: 100,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  Text('Weather today'),
                  Text('07:00     7°C'),
                  Text('08:00     8°C'),
                  Text('09:00     8°C'),
                  Text('10:00     9°C'),
                  Text('11:00    10°C'),
                  Text('12:00    11°C'),
                  Text('13:00    11°C'),
                  Text('14:00    11°C'),
                  Text('15:00    10°C'),
                  Text('16:00    10°C'),
                  Text('17:00     9°C'),
                  Text('18:00     8°C'),
                  Text('19:00     8°C'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
