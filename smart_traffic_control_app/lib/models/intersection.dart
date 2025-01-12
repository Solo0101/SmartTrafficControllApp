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
  // Map<String, dynamic>? entriesCoordinates = {};
  Map<String, List<GeoPoint>>? entriesCoordinates = {};
  Map<String, int>? entriesTrafficScore = {};

  Intersection(
      {required this.id,
      required this.name,
      required this.address,
      required this.coordinates,
      required this.country,
      required this.city,
      required this.entriesNumber,
      required this.individualToggle,
      this.entriesCoordinates,
      this.entriesTrafficScore});

  factory Intersection.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> tempEntriesCoordinatesMap = json['entriesCoordinates'] == null ? {} : json['entriesCoordinates'] as Map<String, dynamic>;
    Map<String, List<GeoPoint>> generatedEntriesCoordinatesMap = {};
    int i = 0;
    for (var v in tempEntriesCoordinatesMap.values) {
      List<GeoPoint> tempPointList = [];
      tempPointList.add(GeoPoint(v[0].latitude, v[0].longitude));
      tempPointList.add(GeoPoint(v[1].latitude, v[1].longitude));
      generatedEntriesCoordinatesMap.update("entrieNumber$i", (value) => tempPointList, ifAbsent: () => tempPointList);
      i++;
    }

    Map<String, dynamic> tempEntriesTrafficScoreMap = json['entriesTrafficScore'] == null ? {} : json['entriesTrafficScore'] as Map<String, dynamic>;
    Map<String, int> generatedEntriesTrafficScoreMap = {};
    i = 0;
    for (var v in tempEntriesTrafficScoreMap.values) {
      generatedEntriesTrafficScoreMap.update("entrieNumber$i", (value) => value, ifAbsent: () => v);
      i++;
    }

    //
    return Intersection(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        coordinates: json['coordXY'],
        country: json['country'],
        city: json['city'],
        entriesNumber: json['entriesNumber'],
        individualToggle: json['individualToggle'],
        entriesCoordinates: generatedEntriesCoordinatesMap,
        entriesTrafficScore: generatedEntriesTrafficScoreMap);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'coordXY': coordinates,
        'country': country,
        'city': city,
        'entriesNumber': entriesNumber,
        'individualToggle': individualToggle,
        'entriesCoordinates': entriesCoordinates
      };
}
