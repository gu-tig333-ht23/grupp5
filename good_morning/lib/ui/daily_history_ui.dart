import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_history.dart';
import 'package:provider/provider.dart';

class DailyHistoryPage extends StatefulWidget {
  final ThemeData theme;

  const DailyHistoryPage({required this.theme});

  @override
  State<DailyHistoryPage> createState() => _DailyHistoryPageState();
}

class _DailyHistoryPageState extends State<DailyHistoryPage> {
  @override
  Widget build(BuildContext context) {
    var historyProvider = Provider.of<HistoryProvider>(context);


    return Scaffold(
        appBar: AppBar(
          actions: [
            DropdownButton<String>(
                value: context.read<HistoryProvider>().filter,
                onChanged: (newValue) {
                  setState(() {
                    context.read<HistoryProvider>().filter = newValue!;
                    context.read<HistoryProvider>().notifyListeners();
                  });
                },
                items: [
                  'All',
                  'Selected',
                  'Births',
                  'Deaths',
                  'Events',
                  'Holidays'
                ].map((filter) {
                  return DropdownMenuItem<String>(
                    value: (filter),
                    child: Text(filter),
                  );
                }).toList()),
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Good Morning'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 250, 250, 250),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      //'Föddes Penei Sewell (American football player)',
                      historyProvider.historyitem[0].text,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Name/händelse',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      GestureDetector(
                        onTap: () {
                          // historyProvider.fetchHistoryItem();
                          historyProvider.fetchHistoryItem3();
                        },
                        child: Container(
                          height: 500,
                          width: 400,
                          decoration: BoxDecoration(
                            color: const Color(0xff7c94b6),
                            image: DecorationImage(
                              image: NetworkImage(
                                historyProvider.historyitem[0].thumbnail,
                                //'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Penei_Sewell_%2852480402764%29_%28cropped%29.jpg/320px-Penei_Sewell_%2852480402764%29_%28cropped%29.jpg'
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                          //'Desctiption here: Penei Sewell is an American football offensive tackle for the Detroit Lions of the National Football League (NFL). He played college football at Oregon, where he won the Outland and Morris trophies in 2019.',
                          historyProvider.historyitem[0].extract,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                ),
              ),
            ],
          ),
        ));
  }
}
