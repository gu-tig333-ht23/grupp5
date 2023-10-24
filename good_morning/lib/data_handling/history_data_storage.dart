import 'package:shared_preferences/shared_preferences.dart';

//Lagring för daily history

Future<void> storeHistoryData({
    required String historyText,
    required String historyThumbnail,
    required String historyExtract,
    }) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('historyText', historyText);
  prefs.setString('historyThumbnail', historyThumbnail);
  prefs.setString('historyExtract', historyExtract);
  print('i STORE history data funktionen i lagringen');
  print(prefs.getString('historyText'));
  print(prefs.getString('historyThumbnail'));
  print(prefs.getString('historyExtract'));
}

Future<Map<String, dynamic>> getHistoryData() async {
  final prefs = await SharedPreferences.getInstance();
  final text = prefs.getString('historyText');
  final thumbnail = prefs.getString('historyThumbnail');
  final extract = prefs.getString('historyExtract');
  print('i GET history data funktionen i lagringen');
  print(text);
  print(thumbnail);
  print(extract);

  return {
    'historyText': text ?? '',
    'historyThumbnail': thumbnail ?? '',
    'historyExtract': extract ?? '',
  };
}

Future<void> storeHistorySetting(
  String selectedFilter,
) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('selectedFilter', selectedFilter);
}

Future<Map<String, String>> getSettingsData() async {
  final prefs = await SharedPreferences.getInstance();
  final selectedFilter = prefs.getString('selectedFilter');
  
  return {
    'selectedFilter': selectedFilter ?? '',
    
  };
}

