import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../constants/style_constants.dart';
import '../pages/intersection_page.dart';

class MyCard extends StatelessWidget {
  final String id;
  final String name;
  final String address;
  final GeoPoint coordinates;
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IntersectionPage(intersectionId: id),
            ),
          );
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
                  leading: const Icon(Icons.traffic_rounded,
                      color: primaryTextColor),
                  // const Icon(Icons.traffic_outlined, color: primaryTextColor),
                  title: Text(name,
                      style: const TextStyle(color: primaryTextColor)),
                  subtitle: Text(address,
                      style: const TextStyle(color: placeholderTextColor)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        MapsLauncher.launchCoordinates(
                            coordinates.latitude, coordinates.longitude);
                      },
                      icon: const Icon(Icons.pin_drop_rounded,
                          color: primaryTextColor),
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
}
