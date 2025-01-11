import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_traffic_control_app/models/intersection.dart';

CollectionReference intersections =
    FirebaseFirestore.instance.collection('intersections');

class DatabaseService {
  static Future<void> fetchIntersections() async {
    try {
      final response = await intersections.get();
      if (response.docs.isNotEmpty) {
        for (var doc in response.docs) {
          if (kDebugMode) {
            print(doc.data());
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to fetch data: $e");
      }
    }
  }

  static Future<Intersection> fetchIntersectionById(String id) async {
    try {
      final response = await intersections.doc(id).get();
      if (response.exists) {
        if (kDebugMode) {
          print(response.data());
        }
        return Intersection.fromJson(response.data() as Map<String, dynamic>);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to fetch data: $e");
      }
    }
    return Intersection(
      id: '',
      name: '',
      address: '',
      coordinates: const GeoPoint(0, 0),
      country: '',
      city: '',
      entriesNumber: 0,
      individualToggle: false,
    );
  }
}
