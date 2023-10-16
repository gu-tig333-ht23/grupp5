import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_history.dart';
import 'package:provider/provider.dart';

class DailyHistoryPage extends StatefulWidget {
  final ThemeData theme;
  

  const DailyHistoryPage({super.key, required this.theme,});

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
    //HistoryItem item = historyProvider.fetchHistoryItem3();
    print('start history ui innan return scaffold');
    return Scaffold(
        appBar: AppBar(
          
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
                      historyProvider.item.text,
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
                          
                        },
                        child: Container(
                          height: 500,
                          width: 400,
                          decoration: BoxDecoration(
                            color: const Color(0xff7c94b6),
                            image: DecorationImage(
                              image: NetworkImage(
                                historyProvider.item.thumbnail,
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
                          historyProvider.item.extract,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                ),
              ),
            ],
          ),
        ));
  }
}
