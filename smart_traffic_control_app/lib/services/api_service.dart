import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';

import 'package:smart_traffic_control_app/constants/api_constants.dart';
import 'package:smart_traffic_control_app/models/intersection.dart';

import '../constants/style_constants.dart';

// import 'package:smart_traffic_control_app/models/user.dart';
// import 'package:smart_traffic_control_app/services/hive_service.dart';
// import 'package:smart_traffic_control_app/providers/token_provider.dart';

class ApiService {
  ApiService._();

  static Future<List<Intersection>> fetchIntersections() async {
    var url = Uri.https(ApiConstants.baseUrl, ApiConstants.appGetAllIntersectionsEndpoint);
    try {
      var response = await http.get(url, headers: ApiConstants.apiHeader);
      if (response.statusCode == 200) {
        // var responseMap = jsonDecode(response.body);
        var responseMap = jsonDecode(response.body);
        List<Intersection> intersectionList = [];
        for (int i = 0; i < responseMap.length; ++i) {
          Intersection intersection = Intersection.fromJson(responseMap[i]);
          intersectionList.add(intersection);
        }
        if (kDebugMode) {
          print(intersectionList);
        }
        return intersectionList;
      } else {
        if (kDebugMode) {
          print(response.statusCode);
        }
        return [];
      }
    } catch (e) {
      throw Exception("Failed to fetch intersections: $e");
    }
  }

  static Future<Intersection?> fetchIntersection(String id) async {
    var url = Uri.https(ApiConstants.baseUrl, "${ApiConstants.appGetIntersectionEndpoint}/$id");
    try {
      var response = await http.get(url, headers: ApiConstants.apiHeader);
      if (response.statusCode == 200) {
        var responseMap = jsonDecode(response.body);
        Intersection intersection = Intersection.fromJson(responseMap);
        if (kDebugMode) {
          print(intersection);
        }
        return intersection;
      } else {
        if (kDebugMode) {
          print(response.statusCode);
        }
        return null;
      }
    } catch (e) {
      throw Exception("Failed to fetch intersection: $e");
    }
  }

  static Future<void> addIntersection(Intersection intersection) async {
    var url = Uri.https(ApiConstants.baseUrl, ApiConstants.appCreateIntersectionEndpoint);
    try {
      var response = await http.post(
          url,
          headers: ApiConstants.apiHeader,
          body: jsonEncode(intersection.toJson())
      );

      if (response.statusCode == 201) {
        // Successful POST request, handle the response here
        final responseData = jsonDecode(response.body);
        if (kDebugMode) {
          print(responseData);
        }
      } else {
        // If the server returns an error response, throw an exception
        if (kDebugMode) {
          print(jsonDecode(response.body));
        }
        throw Exception('Failed to post data');
      }
    } catch (e) {
      throw Exception('Failed to post data! $e');
    }
  }

  static Future<http.Response> updateIntersection(Intersection intersection) async {
    var url = Uri.https(ApiConstants.baseUrl, "${ApiConstants.appUpdateIntersectionEndpoint}/${intersection.id}");
    // var token = await appToken;
    try {
      var response = await http.put(
        url,
        headers: ApiConstants.apiHeader,
        body: jsonEncode(intersection.toJson())
      );

      if (response.statusCode == 200) {
        // Successful POST request, handle the response here
        final responseData = jsonDecode(response.body);
        if (kDebugMode) {
          print(responseData);
        }
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to post data');
      }
      return response;
    } catch (e) {
      throw Exception('Failed to post data! $e');
    }
  }

  static Future<http.Response> deleteIntersection(String id) async {
    var url = Uri.https(ApiConstants.baseUrl, "${ApiConstants.appDeleteIntersectionEndpoint}/$id");
    try {
      var response = await http.delete(url, headers: ApiConstants.apiHeader);
      if (kDebugMode) {
        print(response.body);
      }
      return response;
    } catch (e) {
      throw("Failed to delete intersection: $e");
    }
  }

  static Future<http.Response> toggleTrafficLights(String id) async {
    // var url = Uri.https(ApiConstants.baseUrl, "${ApiConstants.appToggleTrafficLightsEndpoint}/$id"); // TODO: Solve Send Request with Id in the backend
    var url = Uri.https(ApiConstants.baseUrl, ApiConstants.appToggleTrafficLightsEndpoint);
    try {
      var response = await http.post(url, headers: ApiConstants.apiHeader);
      if (kDebugMode) {
        print(response.body);
      }
      return response;
    } catch (e) {
      throw("Failed to toggle traffic lights: $e");
    }
  }

  static Future<http.Response> trafficLightsAllRed(String id) async {
    // var url = Uri.https(ApiConstants.baseUrl, "${ApiConstants.appTrafficLightsAllRedEndpoint}/$id"); // TODO: Solve Send Request with Id in the backend
    var url = Uri.https(ApiConstants.baseUrl, ApiConstants.appTrafficLightsAllRedEndpoint);
    try {
      var response = await http.post(url, headers: ApiConstants.apiHeader);
      if (kDebugMode) {
        print(response.body);
      }
      return response;
    } catch (e) {
      throw("Failed to toggle all red traffic lights: $e");
    }
  }

  static Future<http.Response> trafficLightsHazardMode(String id) async {
    // var url = Uri.https(ApiConstants.baseUrl, "${ApiConstants.appTrafficLightsHazardModeEndpoint}/$id"); // TODO: Solve Send Request with Id in the backend
    var url = Uri.https(ApiConstants.baseUrl, ApiConstants.appTrafficLightsHazardModeEndpoint);
    try {
      var response = await http.post(url, headers: ApiConstants.apiHeader);
      if (kDebugMode) {
        print(response.body);
      }
      return response;
    } catch (e) {
      throw("Failed to toggle hazard mode: $e");
    }
  }

  static Future<http.Response> turnOffTrafficLights(String id) async {
    // var url = Uri.https(ApiConstants.baseUrl, "${ApiConstants.appTurnOffTrafficLightsEndpoint}/$id"); // TODO: Solve Send Request with Id in the backend
    var url = Uri.https(ApiConstants.baseUrl, ApiConstants.appTurnOffTrafficLightsEndpoint);
    try {
      var response = await http.post(url, headers: ApiConstants.apiHeader);
      if (kDebugMode) {
        print(response.body);
      }
      return response;
    } catch (e) {
      throw("Failed to turn off traffic lights: $e");
    }
  }

  static Future<http.Response> resumeTrafficLights(String id) async {
    // var url = Uri.https(ApiConstants.baseUrl, "${ApiConstants.appResumeTrafficLightsEndpoint}/$id"); // TODO: Solve Send Request with Id in the backend
    var url = Uri.https(ApiConstants.baseUrl, ApiConstants.appResumeTrafficLightsEndpoint);
    try {
      var response = await http.post(url, headers: ApiConstants.apiHeader);
      if (kDebugMode) {
        print(response.body);
      }
      return response;
    } catch (e) {
      throw("Failed to resume traffic lights: $e");
    }
  }

  static Future<http.Response> toggleSmartAlgorithm(String id) async {
    // var url = Uri.https(ApiConstants.baseUrl, "${ApiConstants.appToggleSmartAlgorithmEndpoint}/$id"); // TODO: Solve Send Request with Id in the backend
    var url = Uri.https(ApiConstants.baseUrl, ApiConstants.appToggleSmartAlgorithmEndpoint);
    try {
      var response = await http.post(url, headers: ApiConstants.apiHeader);
      if (kDebugMode) {
        print(response.body);
      }
      return response;
    } catch (e) {
      throw("Failed to toggle smart algorithm: $e");
    }
  }

  static Future<IntersectionRealtimeData> getStatistics(String id) async {
    var url = Uri.https(ApiConstants.baseUrl, "${ApiConstants.appGetStatisticsEndpoint}/$id");
    try {
      var response = await http.get(url, headers: ApiConstants.apiHeader);
      if (kDebugMode) {
        print(jsonDecode(response.body));
        }
      return IntersectionRealtimeData.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw("Failed to get statistics: $e");
    }
  }

  static Future<void> resetStatistics(String id) async {
    var url = Uri.https(ApiConstants.baseUrl, "${ApiConstants.appResetStatisticsEndpoint}/$id");
    try {
      await http.post(url, headers: ApiConstants.apiHeader);
      return;
    } catch (e) {
      throw("Failed to reset statistics: $e");
    }
  }

  static Future<Map<String, dynamic>> getCurrentStatus(String id) async {
    var url = Uri.https(ApiConstants.baseUrl, "${ApiConstants.appGetCurrentIntersectionStatusEndpoint}/$id");
    try {
      var response = await http.get(url, headers: ApiConstants.apiHeader);
      if (kDebugMode) {
        print(jsonDecode(response.body));
      }
      return {
        "connected": jsonDecode(response.body)["connected"],
        "state": jsonDecode(response.body)["state"]
      };
    } catch (e) {
      throw("Failed to get current status: $e");
    }
  }

  static Future<void> onPressedApiCall({required bool isSaving, required BuildContext context, required Future apiCall, required StateSetter setState, required String actionText, required String errorText}) async {
    setState(() {
      isSaving = true;
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        // User cannot dismiss it
        builder: (BuildContext context) {
          return const Center(
              child: CircularProgressIndicator(
                  color: utilityButtonColor));
        });
    try {
      apiCall;
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true)
            .pop();
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
                '$actionText successfully!',
                style: const TextStyle(
                    color: primaryTextColor)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true)
            .pop(); // Dismiss loading dialog on error
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
                'Error $errorText: $e',
                style: const TextStyle(
                    color: primaryTextColor)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (context.mounted) {
        setState(() {
          isSaving = false; // End loading
        });
      }
    }
  }

}