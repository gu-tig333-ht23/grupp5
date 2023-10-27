import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:good_morning/data_handling/secrets.dart' as config;
import 'package:flutter/material.dart';
import 'package:good_morning/utils/daily_traffic/daily_traffic_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// API call code and widgets here
const String mapApiKey = config.mapApiKey;

// Google Maps Address Validation API

Future<bool> isAddressValidLocation(String address) async {
  String validationURL =
      'https://addressvalidation.googleapis.com/v1:validateAddress';

  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  Map<String, dynamic> requestBody = {
    'address': {
      'addressLines': [address],
      'regionCode': 'SE', // Sweden
    },
  };

  if (kIsWeb) {
    validationURL =
        'https://cors-anywhere.herokuapp.com/$validationURL?key=$mapApiKey';
  } else {
    validationURL = '$validationURL?key=$mapApiKey';
  }

  final response = await http.post(
    Uri.parse(validationURL),
    headers: headers,
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    // if successful response, parse the JSON response
    var responseData = json.decode(response.body);
    var verdict = responseData['result']['verdict']['validationGranularity'];

    if (verdict == 'PREMISE' ||
        verdict == 'SUB-PREMISE' ||
        verdict == 'PREMISE_PROXIMITY') {
      return true;
    } else {
      return false;
    }
  } else {
    throw Exception('Failed to validate address');
  }
}

// Google Maps Geocoding API
Future<String?> getAddressFromLatLng(String latitude, String longitude) async {
  String geoCodingURL;
  if (kIsWeb) {
    // for running in web browsers, sends request through proxy server https://cors-anywhere.herokuapp.com (click there for access first!)
    geoCodingURL =
        'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/geocode/json';
  } else {
    // for running in emulators
    geoCodingURL = 'https://maps.googleapis.com/maps/api/geocode/json';
  }
  final response = await http.get(
      Uri.parse('$geoCodingURL?latlng=$latitude,$longitude&key=$mapApiKey'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    if (data['status'] == 'OK') {
      // Extract the formatted address from the response
      return data['results'][0]['formatted_address'];
    } else {
      // Handle API error if necessary
      if (kDebugMode) {
        print('Error: ${data['status']} - ${data['error_message']}');
      }
      return null;
    }
  } else {
    // Handle HTTP error if necessary
    if (kDebugMode) {
      print('Error: ${response.statusCode}');
    }
    return null;
  }
}

// Google Maps Directions API

Future<Map<String, dynamic>> getRouteInfoFromAPI(
    String toAddress, String fromAddress, String mode) async {
  String mapUrl;
  if (kIsWeb) {
    // for running in web browsers, sends request through proxy server https://cors-anywhere.herokuapp.com (click there for access first!)
    mapUrl =
        'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/directions/json';
  } else {
    // for running in emulators
    mapUrl = 'https://maps.googleapis.com/maps/api/directions/json';
  }
  http.Response response = await http.get(Uri.parse(
      '$mapUrl?mode=$mode&destination=$toAddress&origin=$fromAddress&language=en&key=$mapApiKey'));

  if (response.statusCode == 200) {
    // the server returned 200 OK response
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  } else {
    throw Exception('Failed to load route information');
  }
}

Future<Uint8List> getMapFromAPI(
    String toAddress, String fromAddress, String mode) async {
  String directionsUrl;
  String embedStaticUrl;

  if (kIsWeb) {
    // for running in web browsers, sends request through proxy server https://cors-anywhere.herokuapp.com (click there for access first!)
    directionsUrl =
        'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/directions/json';

    embedStaticUrl =
        'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/staticmap';
  } else {
    // for running in emulators, without proxy
    directionsUrl = 'https://maps.googleapis.com/maps/api/directions/json';
    embedStaticUrl = 'https://maps.googleapis.com/maps/api/staticmap';
  }
  String markers =
      'markers=color:red|label:A|$fromAddress&markers=color:blue|label:B|$toAddress';
  String request =
      '$directionsUrl?mode=$mode&destination=$toAddress&origin=$fromAddress&key=$mapApiKey';
  if (kDebugMode) {
    print('Sends request to API: $request');
  }

  // gets the direction data from API, decodes and encodes
  http.Response directionsResponse = await http.get(Uri.parse(
      '$directionsUrl?mode=$mode&destination=$toAddress&origin=$fromAddress&alternatives=true&key=$mapApiKey'));
  if (directionsResponse.statusCode == 200) {
    // if OK
    Map<String, dynamic> data = json.decode(directionsResponse.body);
    String polylineCoordinates =
        data['routes'][0]['overview_polyline']['points'];

    // builds the path for the route line
    String path = '&path=color:0x0000ff|weight:5|enc:$polylineCoordinates';

    // builds the static map url with polyline and markers
    String mapUrl =
        '$embedStaticUrl?size=600x300&$markers$path&key=$mapApiKey&mode=$mode';

    // gets the static map with route line and markers from API
    http.Response mapResponse = await http.get(Uri.parse(mapUrl));

    if (mapResponse.statusCode == 200) {
      // OK Response
      return mapResponse.bodyBytes;
    } else {
      throw Exception('Failed to load map');
    }
  } else {
    throw Exception('Failed to fetch directions');
  }
}

// Widget to show the map image with FutureBuilder
class GoogleMapWidget extends StatelessWidget {
  final bool isClickable;
  final Future<Uint8List> mapImage;

  const GoogleMapWidget(
      {super.key, required this.mapImage, required this.isClickable});

  @override
  Widget build(BuildContext context) {
    String fromDest = Provider.of<DailyTrafficProvider>(context, listen: false)
        .currentTo
        .address;
    String toDest = Provider.of<DailyTrafficProvider>(context, listen: false)
        .currentFrom
        .address;
    String mode = Provider.of<DailyTrafficProvider>(context, listen: false)
        .mode
        .name
        .toString();

    String mapLinkUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$fromDest&destination=$toDest&travelmode=$mode';

    return FutureBuilder<Uint8List>(
      future: mapImage,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while waiting for the future to complete
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Show error message if future completes with an error
        } else if (snapshot.hasData) {
          // If the future completes successfully, display the map image

          return GestureDetector(
            onTap: () {
              if (isClickable) {
                _launchURL(
                    mapLinkUrl); // routes to Google Maps for directions for the actual route shown
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            ),
          ); // Display the Uint8List image data
        } else {
          return const Text(
              'No data'); // Show a default message if there's no data
        }
      },
    );
  }

  _launchURL(String url) async {
    Uri uriLink = Uri.parse(url);
    if (await canLaunchUrl(uriLink)) {
      await launchUrl(uriLink);
    } else {
      throw 'Could not launch url';
    }
  }
}

// Widget to show the route information with FutureBuilder
class MapInfoWidget extends StatelessWidget {
  final Future<Map<String, dynamic>> routeInfo;

  const MapInfoWidget({super.key, required this.routeInfo});

  @override
  Widget build(BuildContext context) {
    var currentFrom = context.watch<DailyTrafficProvider>().currentFrom;
    var currentTo = context.watch<DailyTrafficProvider>().currentTo;
    var transportMode = context.watch<DailyTrafficProvider>().mode;

    return FutureBuilder<Map<String, dynamic>>(
        future: routeInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: $snapshot.error}');
          } else if (snapshot.hasData) {
            var routeInfo = snapshot.data!;
            var duration =
                routeInfo['routes'][0]['legs'][0]['duration']['text'];
            var distance =
                routeInfo['routes'][0]['legs'][0]['distance']['text'];
            String from = currentFrom.name != null
                ? currentFrom.name!.toLowerCase()
                : currentFrom.address;
            String to = currentTo.name != null
                ? currentTo.name!.toLowerCase()
                : currentTo.address;

            String routeInfoText =
                '$duration from $from to $to if ${transportMode.name.toString()}. Distance is $distance.';

            return Text(
              routeInfoText,
            );
          } else {
            return const Text('No data');
          }
        });
  }
}
