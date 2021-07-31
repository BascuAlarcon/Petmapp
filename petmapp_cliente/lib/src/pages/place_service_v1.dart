import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

class Place {
  String streetNumber;
  String street;
  String city;
  String latitud;
  String longitud;

  Place({
    this.streetNumber,
    this.street,
    this.city,
    this.latitud,
    this.longitud,
  });

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, latitud: $latitud, longitud: $longitud))';
  }
}

class Suggestion {
  final String placeId;
  final String description;
  final String geocode;

  Suggestion(this.placeId, this.description, this.geocode);

  @override
  String toString() {
    return 'Suggestion(description: $description, geocode : $geocode , placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static final String androidKey = 'AIzaSyBMmrmZgl13qldBX5yjZHVCpb8rMQ6BGvM';
  static final String iosKey = 'AIzaSyBMmrmZgl13qldBX5yjZHVCpb8rMQ6BGvM';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Suggestion>> fetchSuggestions(
    String input,
  ) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=es-Es&components=country:cl&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) =>
                Suggestion(p['place_id'], p['description'], p['geocode ']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component,geometry&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
            result['result']['address_components'] as List<dynamic>;
        final viewport = result['result']['geometry']['viewport']['southwest']
            as Map<String, dynamic>;
        // build result
        final place = Place();
        components.forEach((c) {
          final List type = c['types'];
          if (type.contains('street_number')) {
            place.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            place.street = c['long_name'];
          }
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
        });
        int cont = 0;
        for (var respuesta in viewport.values) {
          if (cont == 0) {
            place.latitud = respuesta.toString();
          } else {
            place.longitud = respuesta.toString();
          }
          cont++;

          // v.asMap().forEach((i, value) {
          //   print('index=$i, value=$value');
          // });
        }
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
