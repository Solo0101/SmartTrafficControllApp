import 'package:cloud_firestore/cloud_firestore.dart';

class Intersection {
  final String id;
  final String name;
  final String address;
  final GeoPoint coordinates;
  final String country;
  final String city;
  final int entriesNumber;
  final bool individualToggle;

  Intersection(
      {required this.id,
      required this.name,
      required this.address,
      required this.coordinates,
      required this.country,
      required this.city,
      required this.entriesNumber,
      required this.individualToggle});

  factory Intersection.fromJson(Map<String, dynamic> json) {
    return Intersection(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        coordinates: json['coordinates'],
        country: json['country'],
        city: json['city'],
        entriesNumber: json['entriesNumber'],
        individualToggle: json['individualToggle']);
  }
}
