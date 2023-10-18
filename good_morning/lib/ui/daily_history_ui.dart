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
              buildFullCard(context, title :historyProvider.item.text,
                  description: historyProvider.item.extract,),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                color: Theme.of(context).cardColor,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: historyProvider.item.thumbnail,
                      ),
                    
                    ),
                    
                      
                  ),
                
              
            ],
          ),
        ));
  }
}