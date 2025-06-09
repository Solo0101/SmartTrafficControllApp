import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';

import 'package:smart_traffic_control_app/constants/api_constants.dart';
import 'package:smart_traffic_control_app/models/intersection.dart';

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
    print(jsonEncode(intersection.toJson()));
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

      if (response.statusCode == 201) {
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

// static Future<User> fetchUser(WidgetRef ref) async {
//   var url = Uri.https(ApiConstants.baseUrl, ApiConstants.appGetUserByIdEndpoint);
//   var token = await _getDefaultHeader(ref);
//   var response = await http.get(url, headers: {
//     'accept': '*/*',
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $token'
//   });
//
//   var responseMap = jsonDecode(response.body);
//   var data = responseMap["data"];
//   return User.fromJson(data);
// }
//
//
//
// static Future<int> updateUser(User user, Future<String> applicationToken) async {
//   var url = Uri.https(ApiConstants.baseUrl, ApiConstants.appUpdateUserByIdEndpoint);
//   var token = await applicationToken;
//   var image = await ApiService.getImage();
//   var stream = http.ByteStream(Stream.castFrom(image!.openRead()));
//   final int length = await image!.length();
//
//   var request = http.MultipartRequest('PUT', url)
//     ..headers.addAll({
//       'accept': '*/*',
//       'Content-Type': 'multipart/form-data',
//       'Authorization': 'Bearer $token'})
//     ..files.add(http.MultipartFile('image', stream, length, filename: image!.path.split('/').last))
//     ..fields['email'] = user.email
//     ..fields['name'] = user.name
//     ..fields['country'] = user.country
//     ..fields['countyOrState'] = user.countyOrState
//     ..fields['city'] = user.city
//     ..fields['phoneNumber'] = user.phoneNumber
//     ..fields['id'] = user.id;
//
//
//   var response = await http.Response.fromStream(await request.send());
//   if (kDebugMode) {
//     print(response.body);
//   }
//   return response.statusCode;
// }
}