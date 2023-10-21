import 'package:flutter/material.dart';
import 'package:good_morning/ui/common_ui.dart';
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
        child: Column(
          children: [
            buildFullCard(
              context,
              title: 'Did you know that...?',
              optionalWidget: Row(
                children: [
                  Expanded(
                    child: DailyFactWidget(
                        factText:
                            Provider.of<DailyFactProvider>(context).factText),
                  ),
                  IconButton(
                    icon: Icon(Icons.lightbulb, size: 50),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
