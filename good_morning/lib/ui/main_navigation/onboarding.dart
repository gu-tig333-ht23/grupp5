import 'package:flutter/material.dart';
import 'package:good_morning/data_handling/user_preferences.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'package:good_morning/ui/main_navigation/home_page.dart';
import '../../utils/filter_model.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  bool _canSwipe = true;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Gradient currentGradient = Theme.of(context).brightness == Brightness.light
        ? lightModeGradient
        : darkModeGradient;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: currentGradient,
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (pageIndex) {
                  // Unfocus keyboard when swiping away from name input screen
                  if (_currentPage == 1 && pageIndex != 1) {
                    FocusScope.of(context).unfocus();
                  }
                  setState(() {
                    _currentPage = pageIndex;
                    // Don't allow scrolling past name input page without entering a name
                    if (pageIndex == 1) {
                      _canSwipe = _nameController.text.trim().isNotEmpty;
                    } else {
                      _canSwipe = true;
                    }
                  });
                },
                physics: _canSwipe
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                children: [
                  _buildIntroductionPage(),
                  _buildNameInputPage(),
                  _buildCardSelectionPage(),
                ],
              ),
            ),
            _buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroductionPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wb_sunny, size: 100, color: Colors.orange),
            const SizedBox(height: 40),
            const Text(
              "Welcome to Good Morning",
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const Text(
              "Experience a refreshed morning routine with curated content tailored just for you.",
              style: subtitleTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            buildBigButton(context, "Start", () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildNameInputPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Enter Your Name", style: titleTextStyle),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _saveNameAndNavigate();
            },
          ),
          const SizedBox(height: 20),
          buildBigButton(
            context,
            'Continue',
            () {
              _saveNameAndNavigate();
            },
          ),
        ],
      ),
    );
  }

  void _saveNameAndNavigate() async {
    FocusScope.of(context).unfocus();
    if (_nameController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter your name.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _canSwipe = true;
      });
      await setUserName(_nameController.text.trim());
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  Widget _buildCardSelectionPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Select Cards to Show", style: titleTextStyle),
          const SizedBox(height: 20.0),
          Consumer<FilterModel>(
            builder: (context, filterModel, child) => CheckboxListTile(
              title: const Text('Show Weather'),
              subtitle: const Text(
                  'Displays daily weather updates for your preferred location.'),
              value: filterModel.showWeather,
              onChanged: (bool? value) {
                filterModel.toggleWeather();
              },
            ),
          ),
          Consumer<FilterModel>(
            builder: (context, filterModel, child) => CheckboxListTile(
              title: const Text('Show Today in History'),
              subtitle: const Text(
                  'Highlights significant events from the past on this day.'),
              value: filterModel.showHistory,
              onChanged: (bool? value) {
                filterModel.toggleHistory();
              },
            ),
          ),
          Consumer<FilterModel>(
            builder: (context, filterModel, child) => CheckboxListTile(
              title: const Text('Show Fact of the Day'),
              subtitle: const Text('Your daily fun fact.'),
              value: filterModel.showFact,
              onChanged: (bool? value) {
                filterModel.toggleFact();
              },
            ),
          ),
          Consumer<FilterModel>(
            builder: (context, filterModel, child) => CheckboxListTile(
              title: const Text('Show Film of the Day'),
              subtitle: const Text('Learn about one film every day.'),
              value: filterModel.showFilm,
              onChanged: (bool? value) {
                filterModel.toggleFilm();
              },
            ),
          ),
          Consumer<FilterModel>(
            builder: (context, filterModel, child) => CheckboxListTile(
              title: const Text('Show Traffic'),
              subtitle: const Text('Shows your estimated daily commute time.'),
              value: filterModel.showTraffic,
              onChanged: (bool? value) {
                filterModel.toggleTraffic();
              },
            ),
          ),
          buildBigButton(
            context,
            'Finish Setup',
            () {
              setOnboardingCompleted(true);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 46.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
          );
        }),
      ),
    );
  }
}

final Gradient lightModeGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [Colors.yellow[200]!, Colors.orange[100]!],
);

final Gradient darkModeGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [Colors.deepOrange[700]!, Colors.brown[600]!],
);
