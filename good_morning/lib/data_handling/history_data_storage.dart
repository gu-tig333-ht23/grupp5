import 'package:shared_preferences/shared_preferences.dart';

//Lagring för daily history
//Byt ut 'historyString' mot vad som egentligen ska lagras



Future<void> storeHistoryData(
    String text,
    String thumbnail,
    String extract,
    ) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('historyText', text);
  prefs.setString('historyThumbnail', thumbnail);
  prefs.setString('historyExtract', extract);
}

Future<Map<String, dynamic>> getHistoryData() async {
  final prefs = await SharedPreferences.getInstance();
  final title = prefs.getString('historyText');
  final thumbnail = prefs.getString('historyThumbnail');
  final extract = prefs.getString('historyExtract');

  return {
    'historyText': title ?? '',
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

