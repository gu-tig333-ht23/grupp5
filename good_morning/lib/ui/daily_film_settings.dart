import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_film.dart';
import 'package:good_morning/ui/daily_film_page.dart';
import 'package:provider/provider.dart';

class DailyFilmSettingsModel extends ChangeNotifier {
  String _releaseYear = '';

  String get releaseYear => _releaseYear;

  void setReleaseYear(String year) {
    _releaseYear = year;
    notifyListeners();
  }
}

class DailyFilmSettings extends StatelessWidget {
  final ThemeData theme;
  final TextEditingController yearController = TextEditingController();

  DailyFilmSettings({required this.theme});
  String noTitleWarning = '';

  @override
  Widget build(BuildContext context) {
    var settingsModel = context.read<DailyFilmSettingsModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Daily Film Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              getMovie(context, FilmApi(dio));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
//Varningstext om man försöker lägga till en tom note
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(noTitleWarning, style: TextStyle(fontSize: 15)),
            ),

//Textfält för att skriva in sin note
            TextField(
              controller: yearController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter release year',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FilledButton(
                onPressed: () {
                  settingsModel.setReleaseYear(yearController.text);
                  Navigator.pop(context);
                },
                child: Text('Save settings'),
              ),
            ),

//             Padding(
// //Knapp för att lägga till sin note
//               padding: const EdgeInsets.all(15.0),
//               child: FilledButton(
//                 onPressed: () async {
//                   var title = titleController.text;
//                   bool done = false;

// //En note skapas bara om fältet för titeln inte är tomt
//                   if (title != '') {
//                     Note note = Note(null, title, done);
//                     await addNote(note);
//                     noTitleWarning = '';
//                     context.read<MyState>().fetchNotes();
//                     Navigator.pop(context);

// //Om ingen titel skrivs in visas en varningstext
//                   } else {
//                     setState(
//                       () {
//                         noTitleWarning = 'Please enter a title';
//                       },
//                     );
//                   }
//                 },
//                 child: Text('Add note'),
//               ),
//             ),
          ],
        ),
      ),
    );
  }
}
