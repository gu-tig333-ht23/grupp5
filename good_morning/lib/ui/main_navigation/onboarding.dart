import 'package:flutter/material.dart';
import 'package:good_morning/ui/common_ui.dart';
import 'filter_model.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final TextEditingController _nameController = TextEditingController();

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
                  setState(() {
                    _currentPage = pageIndex;
                  });
                },
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
            ElevatedButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: const Text("Start"),
            ),
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
              _pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
          ),
          const SizedBox(height: 20),
          buildBigButton(
            context,
            'Continue',
            () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardSelectionPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Select Cards to Show",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              title: const Text('Show Today in History'),
              value: visibilityModel.showHistory,
              onChanged: (bool? value) {
                visibilityModel.toggleHistory();
              },
            ),
          ),
          Consumer<FilterModel>(
            builder: (context, visibilityModel, child) => CheckboxListTile(
              title: const Text('Show Fact of the Day'),
              value: visibilityModel.showFact,
              onChanged: (bool? value) {
                visibilityModel.toggleFact();
              },
            ),
          ),
          Consumer<FilterModel>(
            builder: (context, visibilityModel, child) => CheckboxListTile(
              title: const Text('Show Film of the Day'),
              value: visibilityModel.showFilm,
              onChanged: (bool? value) {
                visibilityModel.toggleFilm();
              },
            ),
          ),
          buildBigButton(
            context,
            'Finish Setup',
            () {
              Navigator.pop(context);
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
  colors: [Colors.green[700]!, Colors.teal[700]!],
);
