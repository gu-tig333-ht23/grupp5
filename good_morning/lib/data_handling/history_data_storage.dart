import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeHistoryData({
    required String text,
    required String thumbnail,
    required String extract,
    required String year,
    }) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('text', text);
  prefs.setString('thumbnail', thumbnail);
  prefs.setString('extract', extract);
  prefs.setString('year', year);

}
Future<Map<String, dynamic>> getHistoryData() async {
  final prefs = await SharedPreferences.getInstance();
  final text = prefs.getString('text');
  final thumbnail = prefs.getString('thumbnail');
  final extract = prefs.getString('extract');
  final year = prefs.getString('year');
 
  return {
    'text': text ?? '',
    'thumbnail': thumbnail ?? '',
    'extract': extract ?? '',
    'year': year ?? 'N/A',
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