import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_traffic_control_app/models/intersection.dart';

CollectionReference intersections = FirebaseFirestore.instance.collection('intersections');

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

  static Future<Intersection?> fetchIntersectionById(String id) async {
    try {
      final response = await intersections.doc(id).get();
      if (response.exists) {
        var responseJson = response.data() as Map<String, dynamic>;
        responseJson['id'] = id;
        if (kDebugMode) {
          print(responseJson);
        }
        final Intersection intersection = Intersection.fromJson(responseJson);
        return intersection;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to fetch data: $e");
      }
    }
    return null;
  }

  static Future<void> editIntersectionById(String id, Intersection newIntersection) async {
    try {
      await intersections.doc(id).set(newIntersection.toJson());
    } catch (e) {
      if (kDebugMode) {
        print("Failed to edit data: $e");
      }
    }
  }

  static Future<void> deleteIntersectionById(String id) async {
    try {
      await intersections.doc(id).delete();
    } catch (e) {
      if (kDebugMode) {
        print("Failed to delete data: $e");
      }
    }
  }

  static Future<void> addIntersection(Intersection newIntersection) async {
    try {
      final response = await intersections.add(newIntersection.toJson());
      Intersection responseIntersection = Intersection(
        id: response.id,
        name: newIntersection.name,
        address: newIntersection.address,
        coordinates: newIntersection.coordinates,
        country: newIntersection.country,
        city: newIntersection.city,
        entriesNumber: newIntersection.entriesNumber,
        individualToggle: newIntersection.individualToggle,
        smartAlgorithmEnabled: newIntersection.smartAlgorithmEnabled,
        entries: newIntersection.entries
      );
      newIntersection = responseIntersection;
    } catch (e) {
      if (kDebugMode) {
        print("Failed to add data: $e");
      }
    }
  }
}
