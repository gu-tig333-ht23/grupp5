import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_traffic_provider.dart';
import 'package:provider/provider.dart';

class DailyTrafficPage extends StatelessWidget {
  final ThemeData theme;

  const DailyTrafficPage({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    var destinations = context.watch<DailyTrafficProvider>().savedDestinations;

    var currentFrom = context.watch<DailyTrafficProvider>().currentFrom;
    var currentTo = context.watch<DailyTrafficProvider>().currentTo;

    var transportMode = context.watch<DailyTrafficProvider>().mode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Traffic Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Theme.of(context).cardColor,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () {
                            editRouteDialog(context);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Your route ',
                                  style: TextStyle(
                                    fontSize: 22,
                                  )),
                              Icon(Icons.settings),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 20),
                      child: Row(
                        children: [
                          const Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 8.0, bottom: 15),
                                child: Text('From:',
                                    style: TextStyle(fontSize: 20)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30, top: 12, right: 8.0, bottom: 8),
                                child:
                                    Text('To:', style: TextStyle(fontSize: 20)),
                              ),
                            ],
                          ),
                          const SizedBox(
                              width:
                                  20), // Adjust the spacing between the columns if needed
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6.0, right: 6, bottom: 2),
                                  child: DestinationItem(currentFrom),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6.0, right: 6),
                                    child: DestinationItem(currentTo),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              FutureBuilder<Map<String, dynamic>>(
                                  future: getRouteInfoFromAPI(
                                      currentTo.address,
                                      currentFrom.address,
                                      transportMode.name.toString()),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: $snapshot.error}');
                                    } else if (snapshot.hasData) {
                                      var routeInfo = snapshot.data!;
                                      var duration = routeInfo['routes'][0]
                                          ['legs'][0]['duration']['text'];
                                      var distance = routeInfo['routes'][0]
                                          ['legs'][0]['distance']['text'];
                                      String routeInfoText = (currentFrom
                                                      .name !=
                                                  null &&
                                              currentTo.name != null
                                          ? 'Right now it is approximately $duration from ${currentFrom.name!.toLowerCase()} to ${currentTo.name!.toLowerCase()} if ${transportMode.name.toString()}. The distance is $distance.'
                                          : (currentFrom.name != null)
                                              ? 'Right now it is approximately $duration from ${currentFrom.name!.toLowerCase()} to ${currentTo.address} if ${transportMode.name.toString()}. The distance is $distance.'
                                              : 'Right now it is approximately $duration from ${currentFrom.address} to ${currentTo.name!.toLowerCase()} if ${transportMode.name.toString()}. The distance is $distance.');

                                      return Column(children: [
                                        Text(routeInfoText),
                                      ]);
                                    } else {
                                      return Text('No data');
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
