import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_fact_provider.dart';
import 'package:provider/provider.dart';

class DailyFactPage extends StatelessWidget {
  final ThemeData theme;
  const DailyFactPage({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Fact of the Day'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
        child: Card(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('lib/images/bookImage.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.dstATop),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Did you know that...?',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  DailyFactWidget(
                      factText:
                          Provider.of<DailyFactProvider>(context).factText),
                  const SizedBox(height: 20),
                  const Text('Want more facts?',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text(
                    'A new random and fun fact will be retrieved by midnight and be ready for you to see first thing in the morning!',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
