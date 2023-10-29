import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeHistoryData({
    required String text,
    required String thumbnail,
    required String extract,
    }) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('text', text);
  prefs.setString('thumbnail', thumbnail);
  prefs.setString('extract', extract);
}
Future<Map<String, dynamic>> getHistoryData() async {
  final prefs = await SharedPreferences.getInstance();
  final text = prefs.getString('text');
  final thumbnail = prefs.getString('thumbnail');
  final extract = prefs.getString('extract');
 
  return {
    'text': text ?? '',
    'thumbnail': thumbnail ?? '',
    'extract': extract ?? '',
  };
}

Future<void> storeHistorySettings({
  required String filter,
  required String date,
}) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('filter', filter);
  prefs.setString('date', date);
}

Future<Map<String, dynamic>> getHistorySettings() async {
  final prefs = await SharedPreferences.getInstance();
  final filter = prefs.getString('filter');
  final date = prefs.getString('date');
 
  return {
    'filter': filter ?? '',
    'date': date ?? '',
  };
}