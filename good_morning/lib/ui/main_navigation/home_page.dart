import 'package:good_morning/data_handling/user_preferences.dart';
import 'package:good_morning/utils/daily_film.dart';
import 'package:provider/provider.dart';
import '../common_ui.dart';
import 'package:flutter/material.dart';
import 'package:good_morning/ui/daily_history_ui.dart';
import 'package:good_morning/ui/daily_fact/daily_fact_ui.dart';
import '../weather_ui.dart';
import 'package:good_morning/ui/daily_film/daily_film_page.dart';
import 'package:good_morning/ui/daily_traffic.ui.dart';
import 'filter_model.dart';
import 'onboarding.dart';
import 'package:good_morning/utils/daily_history.dart';

class HomePage extends StatefulWidget {
  final String factText;

  HomePage({required this.factText, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getMovie(context, FilmApi(dio));
    //context.read<HistoryProvider>().fetchHistoryItem3();
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Filter Cards'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<FilterModel>(
                builder: (context, visibilityModel, child) => CheckboxListTile(
                  title: const Text('Show Weather'),
                  value: visibilityModel.showWeather,
                  onChanged: (bool? value) {
                    visibilityModel.toggleWeather();
                  },
                ),
              ),
              Consumer<FilterModel>(
                builder: (context, visibilityModel, child) => CheckboxListTile(
                  title: const Text('Show History'),
                  value: visibilityModel.showHistory,
                  onChanged: (bool? value) {
                    visibilityModel.toggleHistory();
                  },
                ),
              ),
              Consumer<FilterModel>(
                builder: (context, visibilityModel, child) => CheckboxListTile(
                  title: const Text('Show Fact'),
                  value: visibilityModel.showFact,
                  onChanged: (bool? value) {
                    visibilityModel.toggleFact();
                  },
                ),
              ),
              Consumer<FilterModel>(
                builder: (context, visibilityModel, child) => CheckboxListTile(
                  title: const Text('Show Film'),
                  value: visibilityModel.showFilm,
                  onChanged: (bool? value) {
                    visibilityModel.toggleFilm();
                  },
                ),
              ),
              Consumer<FilterModel>(
                builder: (context, visibilityModel, child) => CheckboxListTile(
                  title: const Text('Show Traffic'),
                  value: visibilityModel.showTraffic,
                  onChanged: (bool? value) {
                    visibilityModel.toggleTraffic();
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String text = Provider.of<HistoryProvider>(context).item.text;
    String thumbnail = Provider.of<HistoryProvider>(context).item.thumbnail;
    String selectedFilter =
        Provider.of<HistoryProvider>(context).selectedFilter;
    var month = Provider.of<HistoryProvider>(context).mmDate;
    var day = Provider.of<HistoryProvider>(context).ddDate;
    final movieTitle = Provider.of<MovieProvider>(context).movieTitle;
    final posterPath = Provider.of<MovieProvider>(context).moviePosterPath;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: FutureBuilder<String>(
          future:
              getUserName(), // This fetches the name from shared preferences
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text("Good Morning", style: titleTextStyle);
              } else {
                return Text("Good Morning, ${snapshot.data}",
                    style: titleTextStyle);
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<FilterModel>(
          builder: (context, visibilityModel, child) => ListView(
            children: [
              if (visibilityModel.showWeather)
                buildFullCard(context,
                    title: 'Weather',
                    description: 'Show the weather', onTapAction: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => WeatherPage()));
                  print('Navigating to Weather Screen');
                }),
              if (visibilityModel.showTraffic)
                buildFullCard(context,
                    title: 'Traffic',
                    description:
                        'Little traffic, approximately 51 mins to work by bicycle.',
                    onTapAction: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DailyTrafficPage()));
                  print('Navigating to Traffic Information Screen');
                }),
              if (visibilityModel.showHistory)
                buildFullCardWithImage(context,
                    title: 'Today in History',
                    description: text,
                    imageUrl: thumbnail, onTapAction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => DailyHistoryPage(
                        theme: Theme.of(context),
                      ),
                    ),
                  );
                  print('Navigating to Today in History Screen');
                }),
              Row(
                children: [
                  if (visibilityModel.showFact)
                    Expanded(
                      child: buildFullCard(context,
                          title: 'Fact of the Day',
                          description: widget.factText, onTapAction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DailyFactPage(factText: widget.factText),
                          ),
                        );
                        print('Navigating to Fact of the Day Screen');
                      }),
                    ),
                  if (visibilityModel.showFilm)
                    Expanded(
                      child: buildFullCardWithImage(
                        context,
                        title: 'Film of the Day',
                        description: movieTitle,
                        imageUrl: posterPath,
                        onTapAction: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DailyFilmPage(theme: Theme.of(context)),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16.0),
              buildBigButton(context, "Open onboarding", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OnBoardingScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
