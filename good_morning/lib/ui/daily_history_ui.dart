import 'package:flutter/material.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'package:good_morning/utils/daily_film.dart';
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
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    var historyProvider = Provider.of<HistoryProvider>(context);
    String historyFilter = historyProvider.storedHistoryItem.historyFilter;
    var day = historyProvider.now.day;
    var month = historyProvider.now.month;
    var year = historyProvider.now.year;
    var historyText = historyProvider.storedHistoryItem.historyText;

    
    
    print('i UIN');
    print(historyFilter);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: 
        Text('Today: $year-$month-$day: $historyFilter'),
        
        actions: [
          PopupMenuButton<String>(
            initialValue: historyFilter,
            tooltip: 'Choose filter',
            
            // Callback that sets the selected popup menu item.
            onSelected: (String item) {
              setState(() {
                historyProvider.getSelectedFilter(item);
                print(item);
                historyProvider.fetchHistoryItem();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              buildFullCard(
                context,
                title: historyText,
              

              ),
              Card(
                color: Theme.of(context).cardColor,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: historyProvider.storedHistoryItem.historyThumbnail,
                ),
              ),
              buildFullCard(context,description: historyProvider.storedHistoryItem.historyExtract)
            ],
              
            
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            historyProvider.getSelectedFilter(historyFilter);
            historyProvider.fetchHistoryItem();
           
          });
        },
        child: const Icon(Icons.refresh_outlined),
      ),
    );
  }
}
