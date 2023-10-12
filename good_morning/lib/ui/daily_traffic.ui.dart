import 'package:flutter/material.dart';
import 'package:good_morning/ui/common_ui.dart';

class DailyTrafficPage extends StatelessWidget {
  const DailyTrafficPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Traffic Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              color: Theme.of(context).cardColor,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextButton(
                        onPressed: () {}, // ska kunna redigera sen
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
                  ],
                ),
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 15, left: 32, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                        child: Text('From:', style: TextStyle(fontSize: 20)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 30, top: 8, right: 8.0, bottom: 8),
                        child: Text('To:', style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: buildSmallButton(
                            context,
                            'Parallellvägen 13E, Partille',
                            () {},
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: buildSmallButton(
                              context,
                              'Medicinaregatan 15A, Göteborg',
                              () {},
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
                child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image(
                      image: AssetImage('lib/ui/images/exempelbildkarta.jpg')),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
