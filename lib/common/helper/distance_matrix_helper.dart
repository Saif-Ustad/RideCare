import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ridecare/domain/entities/service_provider_entity.dart';

class DistanceMatrixHelper {
  static const _apiKey = '5b3ce3597851110001cf6248922921f6f15b4f6e9d78626c07c5d4eb';
  static const _endpoint =
      'https://api.openrouteservice.org/v2/matrix/driving-car';

  static Future<List<ServiceProviderEntity>> addDistanceAndTime({
    required double userLat,
    required double userLng,
    required List<ServiceProviderEntity> providers,
  }) async {
    final locations = [
      [userLng, userLat], // Origin
      ...providers.map((p) => [
        p.position!.geopoint.longitude,
        p.position!.geopoint.latitude,
      ]),
    ];

    final body = jsonEncode({
      "locations": locations,
      "metrics": ["distance", "duration"],
      "units": "km"
    });

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': _apiKey,
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('ORS API error: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final List distances = data['distances'][0];
    final List durations = data['durations'][0];

    // Start from index 1 because index 0 is user → user
    final enrichedProviders = <ServiceProviderEntity>[];
    for (int i = 1; i < distances.length; i++) {
      final distance = distances[i]; // in km
      final duration = durations[i]; // in seconds

      enrichedProviders.add(
        providers[i - 1].copyWith(
          distanceText: '${distance.toStringAsFixed(1)} km',
          durationText: '${(duration / 60).round()} mins',
        ),
      );
    }

    return enrichedProviders;
  }
}
