import 'package:shared_preferences/shared_preferences.dart';

//Lagring för daily history

Future<void> storeHistoryData({
    required String historyText,
    required String historyThumbnail,
    required String historyExtract,
    required String historyDate,
    required String historyFilter,
    }) async {
      //print('STORE');
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('historyText', historyText);
  prefs.setString('historyThumbnail', historyThumbnail);
  prefs.setString('historyExtract', historyExtract);
  prefs.setString('historyDate', historyDate);
  prefs.setString('historyFilter', historyFilter);
}

Future<Map<String, dynamic>> getHistoryData() async {
  //print('GETSTORED');
  final prefs = await SharedPreferences.getInstance();
  final text = prefs.getString('historyText');
  final thumbnail = prefs.getString('historyThumbnail');
  final extract = prefs.getString('historyExtract');
  final date = prefs.getString('historyDate');
  final filter = prefs.getString('historyFilter');

  return {
    'historyText': text ?? '',
    'historyThumbnail': thumbnail ?? '',
    'historyExtract': extract ?? '',
    'historyDate': date ?? '',
    'historyFilter': filter ?? '',
  };
}
