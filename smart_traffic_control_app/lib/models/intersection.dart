import 'package:geojson_vi/geojson_vi.dart';

class LiveChartData {
  LiveChartData(this.time, this.value);

  final DateTime time;
  final double value;

  factory LiveChartData.fromJson(Map<String, dynamic> json) {
    if (json['timestamp'] == null || json['value'] == null) {
      return LiveChartData(
        DateTime.now(),
        -1,
      );
    }
    return LiveChartData(
      DateTime.parse(json['timestamp']),
      json['value'].toDouble(),
    );
  }
}

class IntersectionRealtimeData {
  final Map<String,
      int> entryTrafficScores; // e.g., {"entry0": 75, "entry1": 50}
  final LiveChartData avgWaitingTimeData;
  final LiveChartData avgVehicleThroughputData;
  final bool intersectionConnectionStatus;

  IntersectionRealtimeData({
    required this.entryTrafficScores,
    required this.avgWaitingTimeData,
    required this.avgVehicleThroughputData,
    required this.intersectionConnectionStatus,
  });

  factory IntersectionRealtimeData.fromJson(Map<String, dynamic> json) {
    Map<String, int> scores = {};
    if (json['entriesTrafficScores'] is Map) {
      (json['entriesTrafficScores'] as Map).forEach((key, value) {
        if (value is int) {
          scores[key] = value;
        }
      });
    }

    // bool status = false;
    // if (json['intersection_connection_status'] == 'True') {
    //   status = true;
    // }

    return IntersectionRealtimeData(
      entryTrafficScores: scores,
      avgWaitingTimeData: LiveChartData.fromJson(json['avgWaitingTimeData']),
      avgVehicleThroughputData: LiveChartData.fromJson(json['avgVehicleThroughputData']),
      intersectionConnectionStatus: json['intersectionConnectionStatus'],
    );
  }
}

class IntersectionEntry {
  final String id;
  final int entryNumber;
  GeoJSONPoint? coordinates1 = GeoJSONPoint([0.0, 0.0]);
  GeoJSONPoint? coordinates2 = GeoJSONPoint([0.0, 0.0]);
  int? trafficScore = 0;

  IntersectionEntry({required this.id,
    required this.entryNumber,
    this.coordinates1,
    this.coordinates2,
    this.trafficScore});

  factory IntersectionEntry.fromJson(Map<String, dynamic> json) {
    IntersectionEntry intersectionEntry = IntersectionEntry(
        id: json['id'],
        entryNumber: json['entryNumber'],
        coordinates1: json['coordinates1'] == null
            ? GeoJSONPoint([0.0, 0.0])
            : GeoJSONPoint.fromJSON(json['coordinates1']),
        coordinates2: json['coordinates2'] == null
            ? GeoJSONPoint([0.0, 0.0])
            : GeoJSONPoint.fromJSON(json['coordinates2']),
        trafficScore: json['trafficScore']);
    return intersectionEntry;
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'entryNumber': entryNumber,
        'coordinates1': coordinates1?.toJSON(),
        'coordinates2': coordinates2?.toJSON(),
        'trafficScore': trafficScore
      };
}

enum ConnectionStatus { unknown, online, offline }

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
  ConnectionStatus connectionStatus;
  List<LiveChartData> avgWaitingTimeDataPoints;
  List<LiveChartData> avgVehicleThroughputDataPoints;
  String currentState;

  Intersection({required this.id,
    required this.name,
    required this.address,
    required this.coordinates,
    required this.country,
    required this.city,
    required this.entriesNumber,
    required this.individualToggle,
    required this.smartAlgorithmEnabled,
    this.entries,
    this.connectionStatus = ConnectionStatus.unknown,
    this.currentState = 'Unknown',
    this.avgWaitingTimeDataPoints = const [],
    this.avgVehicleThroughputDataPoints = const [],
  });

  factory Intersection.fromJson(Map<String, dynamic> json) {
    List<IntersectionEntry> entriesList = [];
    if (json['entries'] != null && json['entries'] is List) {
      for (var entry in json['entries']) {
        entriesList.add(IntersectionEntry.fromJson(entry));
      }
    }

    List<LiveChartData> avgWaitingTimeDataPointsList = [];
    if (json['avgWaitingTimeDataPoints'] != null && json['avgWaitingTimeDataPoints'] is List) {
      for (var dataPoint in json['avgWaitingTimeDataPoints']) {
        avgWaitingTimeDataPointsList.add(LiveChartData.fromJson(dataPoint));
      }
    }

    List<LiveChartData> avgVehicleThroughputDataPointsList = [];
    if (json['avgVehicleThroughputDataPoints'] != null && json['avgVehicleThroughputDataPoints'] is List) {
      for (var dataPoint in json['avgVehicleThroughputDataPoints']) {
        avgVehicleThroughputDataPointsList.add(LiveChartData.fromJson(dataPoint));
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
        entries: entriesList,
        avgWaitingTimeDataPoints: avgWaitingTimeDataPointsList,
        avgVehicleThroughputDataPoints: avgVehicleThroughputDataPointsList

    );
  }

  Map<String, dynamic> toJson() =>
      {
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
