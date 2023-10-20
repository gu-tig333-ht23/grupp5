import 'package:flutter/material.dart';
import 'package:good_morning/ui/common_ui.dart';

class DailyFactPage extends StatelessWidget {
  final String? factText;

  final ThemeData theme;
  const DailyFactPage({super.key, required this.factText, required this.theme});

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
              description: factText ?? 'No fact available',
              optionalWidget: IconButton(
                icon: Icon(Icons.lightbulb, size: 40),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
