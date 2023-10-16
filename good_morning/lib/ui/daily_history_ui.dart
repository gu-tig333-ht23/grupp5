import 'package:flutter/material.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'package:good_morning/utils/daily_history.dart';
import 'package:provider/provider.dart';

class DailyHistoryPage extends StatefulWidget {
  final ThemeData theme;

  const DailyHistoryPage({
    super.key,
    required this.theme,
  });

  @override
  State<DailyHistoryPage> createState() => _DailyHistoryPageState();
}

class _DailyHistoryPageState extends State<DailyHistoryPage> {
  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is initialized
    Provider.of<HistoryProvider>(context, listen: false).fetchHistoryItem3();
  }

  Widget build(BuildContext context) {
    var historyProvider = Provider.of<HistoryProvider>(context);

    return Scaffold(
        appBar: AppBar(
          actions: [
            DropdownButton<String>(
                value: historyProvider.selectedFilter,
                onChanged: (newValue) {
                  setState(() {
                    historyProvider.setFilter(newValue);
                  });
                },
                items: [
                  'selected',
                  'births',
                  'deaths',
                  'events',
                  'holidays'
                ].map((filter) {
                  return DropdownMenuItem<String>(
                    value: (filter),
                    child: Text(filter),
                  );
                }).toList()),
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Today in History'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildFullCard(context, historyProvider.item.text,
                  historyProvider.item.extract, () {}),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 500,
                  width: 400,
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(
                        historyProvider.item.thumbnail,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}