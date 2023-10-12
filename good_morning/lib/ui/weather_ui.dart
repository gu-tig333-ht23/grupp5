import 'package:flutter/material.dart';

class WeatherPage extends StatelessWidget {
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
              icon: Icon(Icons.place)),
        ],
      ),
    );
  }
}
