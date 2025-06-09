import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:smart_traffic_control_app/services/api_service.dart';

import '../constants/style_constants.dart';
import '../models/intersection.dart';
import '../pages/intersection_page.dart';
import '../services/database_service.dart';

class MyCard extends StatelessWidget {
  final String id;
  final String name;
  final String address;
  final GeoJSONPoint coordinates;
  final String country;
  final String city;

  const MyCard({
    super.key,
    required this.id,
    required this.name,
    required this.address,
    required this.coordinates,
    required this.country,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          final intersection = await fetchIntersectionById(context, id);
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IntersectionPage(intersection: intersection),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
            color: primaryOverlayBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.traffic_rounded, color: primaryTextColor),
                  // const Icon(Icons.traffic_outlined, color: primaryTextColor),
                  title: Text(name, style: const TextStyle(color: primaryTextColor)),
                  subtitle: Text(address, style: const TextStyle(color: placeholderTextColor)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        MapsLauncher.launchCoordinates(coordinates.coordinates.first, coordinates.coordinates.last);
                      },
                      icon: const Icon(Icons.pin_drop_rounded, color: primaryTextColor),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Intersection> fetchIntersectionById(BuildContext context, String id) async {
    try {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(color: utilityButtonColor),
          );
        },
      );
      final response = await ApiService.fetchIntersection(id);
      if (context.mounted) Navigator.of(context).pop();
      if (response != null) {
        if (kDebugMode) {
          print(response.toString());
        }
        response.entries ??= [];
        return response;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to fetch data: $e");
      }
    }
    return Intersection(id: '', name: '', address: '', coordinates: GeoJSONPoint([0, 0]), country: '', city: '', entriesNumber: 0, individualToggle: false, smartAlgorithmEnabled: false, entries: []);
  }
}
