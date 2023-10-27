import 'package:flutter/material.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'package:good_morning/utils/daily_history.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

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
  Future<void>? _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture =
        Provider.of<HistoryProvider>(context, listen: false).bootHistory();
  }

  @override
  Widget build(BuildContext context) {
    var historyProvider = Provider.of<HistoryProvider>(context);
    String historyFilter = historyProvider.historyItem.historyFilter;
    var day = historyProvider.now.day;
    var month = historyProvider.now.month;
    var year = historyProvider.now.year;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Today: $year-$month-$day: $historyFilter'),
        actions: [
          PopupMenuButton<String>(
            initialValue: historyFilter,
            tooltip: 'Choose category',
            onSelected: (String item) {
              setState(() {
                historyProvider.getSelectedFilter(item);
                print(item);
                _historyFuture = historyProvider.fetchHistoryItem();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'selected',
                child: Text('Selected'),
              ),
              const PopupMenuItem<String>(
                value: 'births',
                child: Text('Births'),
              ),
              const PopupMenuItem<String>(
                value: 'deaths',
                child: Text('Deaths'),
              ),
              const PopupMenuItem<String>(
                value: 'events',
                child: Text('Events'),
              ),
              const PopupMenuItem<String>(
                value: 'holidays',
                child: Text('Holidays'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    buildFullCard(
                      context,
                      title: historyProvider.historyItem.historyText,
                    ),
                    Card(
                      color: Theme.of(context).cardColor,
                      child: historyProvider
                              .historyItem.historyThumbnail.isNotEmpty
                          ? FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image:
                                  historyProvider.historyItem.historyThumbnail,
                            )
                          : const Icon(Icons.broken_image,
                              size: 50, color: Colors.grey),
                    ),
                    buildFullCard(context,
                        description:
                            historyProvider.historyItem.historyExtract),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            historyProvider.getSelectedFilter(historyFilter);
            _historyFuture = historyProvider.fetchHistoryItem();
          });
        },
        child: const Icon(Icons.refresh_outlined),
      ),
    );
  }
}
