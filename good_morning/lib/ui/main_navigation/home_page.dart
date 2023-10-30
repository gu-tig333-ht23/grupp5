import 'package:flutter/foundation.dart';
import 'package:good_morning/data_handling/user_preferences.dart';
import 'package:good_morning/utils/daily_fact_provider.dart';
import 'package:good_morning/utils/daily_film.dart';
import 'package:good_morning/utils/daily_traffic/daily_traffic_api.dart';
import 'package:good_morning/utils/daily_traffic/daily_traffic_provider.dart';
import 'package:provider/provider.dart';
import '../common_ui.dart';
import 'package:flutter/material.dart';
import 'package:good_morning/ui/daily_history_ui.dart';
import 'package:good_morning/ui/daily_fact_ui.dart';
import '../weather_ui.dart';
import 'package:good_morning/ui/daily_film/daily_film_page.dart';
import 'package:good_morning/ui/daily_traffic/daily_traffic.ui.dart';
import '../../utils/filter_model.dart';
import 'onboarding.dart';
import 'package:good_morning/utils/daily_history/daily_history_provider.dart';
import 'package:good_morning/utils/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getMovie(context, FilmApi(dio));
    context.read<FavoriteMoviesModel>().loadWatchlist();
    context.read<HistoryProvider>().bootHistory();
    fetchCurrentWeather(context);
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
                builder: (context, filterModel, child) => CheckboxListTile(
                  title: const Text('Weather'),
                  value: filterModel.showWeather,
                  onChanged: (bool? value) {
                    filterModel.toggleWeather();
                  },
                ),
              ),
              Consumer<FilterModel>(
                builder: (context, filterModel, child) => CheckboxListTile(
                  title: const Text('Show Traffic'),
                  value: filterModel.showTraffic,
                  onChanged: (bool? value) {
                    filterModel.toggleTraffic();
                  },
                ),
              ),
              Consumer<FilterModel>(
                builder: (context, filterModel, child) => CheckboxListTile(
                  title: const Text('Show History'),
                  value: filterModel.showHistory,
                  onChanged: (bool? value) {
                    filterModel.toggleHistory();
                  },
                ),
              ),
              Consumer<FilterModel>(
                builder: (context, filterModel, child) => CheckboxListTile(
                  title: const Text('Show Fact'),
                  value: filterModel.showFact,
                  onChanged: (bool? value) {
                    filterModel.toggleFact();
                  },
                ),
              ),
              Consumer<FilterModel>(
                builder: (context, filterModel, child) => CheckboxListTile(
                  title: const Text('Show Film'),
                  value: filterModel.showFilm,
                  onChanged: (bool? value) {
                    filterModel.toggleFilm();
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
    String text = Provider.of<HistoryProvider>(context).historyItem.text;
    String thumbnail =
        Provider.of<HistoryProvider>(context).historyItem.thumbnail;
    var currentFrom = context.watch<DailyTrafficProvider>().currentFrom;
    var currentTo = context.watch<DailyTrafficProvider>().currentTo;
    var transportMode = context.watch<DailyTrafficProvider>().mode;
    Movie movie = context.watch<MovieProvider>().movie;
    final weatherProvider = Provider.of<WeatherProvider>(context);
    Map<String, dynamic> currentWeather = weatherProvider.currentWeather;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: FutureBuilder<String>(
          future:
              getUserName(), // This fetches the name from shared preferences
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text("Good Morning", style: subtitleTextStyle);
              } else {
                return Text("Good Morning, ${snapshot.data}",
                    style: subtitleTextStyle);
              }
            } else {
              return const CircularProgressIndicator();
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
        padding: const EdgeInsets.only(
          top: 8.0,
          left: 10.0,
          right: 10.0,
        ),
        child: Consumer<FilterModel>(
          builder: (context, filterModel, child) => ListView(
            children: [
              if (filterModel.showWeather)
                buildWeatherCard(context, currentWeather: currentWeather,
                    onTapAction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const WeatherPage(),
                    ),
                  );
                  if (kDebugMode) {
                    print('Navigating to Weather Screen');
                  }
                }),
              if (filterModel.showTraffic)
                buildFullCard(
                  context,
                  title: 'Traffic',
                  optionalWidget: Row(
                    children: [
                      Expanded(
                        child: MapInfoWidget(
                            routeInfo: getRouteInfoFromAPI(
                                currentTo.address,
                                currentFrom.address,
                                transportMode.name.toString())),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: GoogleMapWidget(
                            isClickable: false,
                            mapImage: getMapFromAPI(
                                currentTo.address,
                                currentFrom.address,
                                transportMode.name.toString())),
                      ),
                    ],
                  ),
                  onTapAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DailyTrafficPage(theme: Theme.of(context)),
                      ),
                    );
                    if (kDebugMode) {
                      print('Navigating to Traffic Information Screen');
                    }
                  },
                ),
              if (filterModel.showHistory)
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
                  if (kDebugMode) {
                    print('Navigating to Today in History Screen');
                  }
                }),
              if (filterModel.showFact)
                buildFullCard(
                  context,
                  title: 'Fact of the Day',
                  optionalWidget: Row(
                    children: [
                      Expanded(
                        child: DailyFactWidget(
                            factText: Provider.of<DailyFactProvider>(context)
                                .factText),
                      ),
                      Image.asset(
                        'lib/images/bookImage.png',
                        width: 85,
                        height: 85,
                      ),
                    ],
                  ),
                  onTapAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => DailyFactPage(
                          theme: Theme.of(context),
                        ),
                      ),
                    );
                    if (kDebugMode) {
                      print('Navigating to Fact of the Day Screen');
                    }
                  },
                ),
              if (filterModel.showFilm)
                buildFullCardWithImage(
                  context,
                  title: 'Film of the Day',
                  description: movie.title,
                  imageUrl: movie.posterPath,
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
              const SizedBox(height: 16.0),
              buildBigButton(context, "Open onboarding", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OnBoardingScreen()),
                );
              }),
              const SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
    );
  }
}
