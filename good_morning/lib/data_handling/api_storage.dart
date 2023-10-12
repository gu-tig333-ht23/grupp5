import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeApiData(String apiResponse) async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now();
  prefs.setString('apiData', apiResponse);
  prefs.setString('lastApiCallDate', today.toIso8601String());
}

Future<String?> getApiData() async {
  final prefs = await SharedPreferences.getInstance();
  final apiResponse = prefs.getString('apiData');
  final lastApiCallDate = prefs.getString('lastApiCallDate');
  if (apiResponse != null && lastApiCallDate != null) {
    final lastDate = DateTime.parse(lastApiCallDate);
    final currentDate = DateTime.now();
    if (currentDate.isAfter(lastDate)) {
      // Perform a new API call since it's a new day
      return null; // or fetch the data again
    } else {
      // Use the stored API response
      return apiResponse;
    }
  }
  return null; // Handle initial case when no data is stored
}
