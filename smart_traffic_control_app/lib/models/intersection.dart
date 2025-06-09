import 'package:geojson_vi/geojson_vi.dart';

class IntersectionEntry {
  final String id;
  final int entryNumber;
  GeoJSONPoint? coordinates1 = GeoJSONPoint([0.0, 0.0]);
  GeoJSONPoint? coordinates2 = GeoJSONPoint([0.0, 0.0]);
  int? trafficScore = 0;

  IntersectionEntry(
      {required this.id,
        required this.entryNumber,
        this.coordinates1,
        this.coordinates2,
        this.trafficScore});

  factory IntersectionEntry.fromJson(Map<String, dynamic> json) {
    IntersectionEntry intersectionEntry = IntersectionEntry(
        id: json['id'],
        entryNumber: json['entryNumber'],
        coordinates1: json['coordinates1'] == null ? GeoJSONPoint([0.0, 0.0]) : GeoJSONPoint.fromJSON(json['coordinates1']),
        coordinates2: json['coordinates2'] == null ? GeoJSONPoint([0.0, 0.0]) : GeoJSONPoint.fromJSON(json['coordinates2']),
        trafficScore: json['trafficScore']);
    return intersectionEntry;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'entryNumber': entryNumber,
        'coordinates1': coordinates1?.toJSON(),
        'coordinates2': coordinates2?.toJSON(),
        'trafficScore': trafficScore
      };
}

class Intersection {
  final String id;
  final String name;
  final String address;
  final GeoJSONPoint coordinates;
  final String country;
  final String city;
  final int entriesNumber;
  final bool individualToggle;
  final bool smartAlgorithmEnabled;
  List<IntersectionEntry>? entries;

  Intersection(
      {required this.id,
      required this.name,
      required this.address,
      required this.coordinates,
      required this.country,
      required this.city,
      required this.entriesNumber,
      required this.individualToggle,
      required this.smartAlgorithmEnabled,
      this.entries});

  factory Intersection.fromJson(Map<String, dynamic> json) {

    List<IntersectionEntry> entriesList = [];
    if (json['entries'] != null && json['entries'] is List) {
      for (var entry in json['entries']) {
        entriesList.add(IntersectionEntry.fromJson(entry));
      }
    }

    return Intersection(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        coordinates: GeoJSONPoint.fromJSON(json['coordXY']),
        country: json['country'],
        city: json['city'],
        entriesNumber: json['entriesNumber'],
        individualToggle: json['individualToggle'],
        smartAlgorithmEnabled: json['smartAlgorithmEnabled'],
        entries: entriesList);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'coordXY': coordinates.toJSON(),
        'country': country,
        'city': city,
        'entriesNumber': entriesNumber,
        'individualToggle': individualToggle.toString(),
        'smartAlgorithmEnabled': smartAlgorithmEnabled.toString(),
        'entries': entries?.map((entry) => entry.toJson()).toList() ?? [],
      };
}
