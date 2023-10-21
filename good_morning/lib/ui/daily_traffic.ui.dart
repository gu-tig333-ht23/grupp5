import 'package:flutter/material.dart';
import 'package:good_morning/ui/common_ui.dart';
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
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 15.0, bottom: 15),
                                child: Text('From:',
                                    style: TextStyle(fontSize: 20)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 6, bottom: 2),
                                  child: DestinationItem(currentFrom),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 15.0, bottom: 15),
                                child:
                                    Text('To:', style: TextStyle(fontSize: 20)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 6, bottom: 2),
                                  child: DestinationItem(currentTo),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: buildFullCard(
                  context,
                  optionalWidget: Column(
                    children: [
                      GoogleMapWidget(
                          mapImage: getMapFromAPI(
                              currentTo.address,
                              currentFrom.address,
                              transportMode.name.toString())),
                      SizedBox(height: 15),
                      MapInfoWidget(
                        routeInfo: getRouteInfoFromAPI(currentTo.address,
                            currentFrom.address, transportMode.name.toString()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
