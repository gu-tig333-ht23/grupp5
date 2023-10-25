import 'package:shared_preferences/shared_preferences.dart';

//Lagring för daily history

Future<void> storeHistoryData({
    required String historyText,
    required String historyThumbnail,
    required String historyExtract,
    required int historyDate,
    required String historyFilter,
    }) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('historyText', historyText);
  prefs.setString('historyThumbnail', historyThumbnail);
  prefs.setString('historyExtract', historyExtract);
  prefs.setInt('historyDate', historyDate);
  prefs.setString('historyFilter', historyFilter);

  print('i STORE history data funktionen i lagringen');
  print(prefs.getString('historyText'));
  print(prefs.getString('historyThumbnail'));
  print(prefs.getString('historyExtract'));
  print(prefs.getInt('historyDate'));
  print(prefs.getString('historyFilter'));
}

Future<Map<String, dynamic>> getHistoryData() async {
  final prefs = await SharedPreferences.getInstance();
  final text = prefs.getString('historyText');
  final thumbnail = prefs.getString('historyThumbnail');
  final extract = prefs.getString('historyExtract');
  final date = prefs.getInt('historyDate');
  final filter = prefs.getString('historyFilter');


  print('i GET  history data funktionen i lagringen');
  print(text);
  print(thumbnail);
  print(extract);
  print(date);
  print(filter);

  return {
    'historyText': text ?? '',
    'historyThumbnail': thumbnail ?? '',
    'historyExtract': extract ?? '',
    'historyDate': date ?? 0,
    'historyFilter': filter ?? '',
  };
}
/*
Future<void> storeHistoryFilter(
  String selectedFilter,
) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('selectedFilter', selectedFilter);
  print('I STOREDhistory filter');
  print(prefs.getString('selectedFilter'));
}

Future<Map<String, String>> getStoredHistoryFilter() async {
  final prefs = await SharedPreferences.getInstance();
  final selectedFilter = prefs.getString('selectedFilter');
  print('I GET STORED history filter');
  print(selectedFilter);
  
  return {
    'storedFilter': selectedFilter ?? '',
    
  };
}
*/
