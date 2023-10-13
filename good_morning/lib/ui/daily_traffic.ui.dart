import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_traffic_provider.dart';
import 'package:provider/provider.dart';

class DailyTrafficPage extends StatelessWidget {
  const DailyTrafficPage({super.key});

  @override
  Widget build(BuildContext context) {
    var destinations = context.watch<DailyTrafficProvider>().savedDestinations;

    var currentFrom = context.watch<DailyTrafficProvider>().currentFrom;
    var currentTo = context.watch<DailyTrafficProvider>().currentTo;

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
                          }, // ska kunna redigera sen
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
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('lib/ui/images/exempelbildkarta.jpg'),
                    ),
                  ],
                ),
              ),
              Card(
                color: Theme.of(context).cardColor,
                child: Text(currentFrom.name != null && currentTo.name != null
                    ? 'Right now it is approximately 51 minutes from ${currentFrom.name!.toLowerCase()} to ${currentTo.name!.toLowerCase()} by bicycle.'
                    : (currentFrom.name != null)
                        ? 'Right now it is approximately 51 minutes from ${currentFrom.name!.toLowerCase()} to ${currentTo.address} by bicycle.'
                        : 'Right now it is approximately 51 minutes from ${currentFrom.address} to ${currentTo.name!.toLowerCase()} by bicycle.'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
