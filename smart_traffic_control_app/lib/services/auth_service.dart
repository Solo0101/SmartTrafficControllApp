import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:smart_traffic_control_app/models/user.dart' ;
import 'package:smart_traffic_control_app/pages/home_page.dart';
import 'package:smart_traffic_control_app/pages/login_page.dart';
import 'package:smart_traffic_control_app/services/hive_service.dart';
import 'package:smart_traffic_control_app/constants/api_constants.dart';
import 'package:smart_traffic_control_app/constants/style_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String snackText = '';

enum AuthResponse { success, invalidCredentials, badRequest, randomError, passwordConfirmNotMatching }

class AuthService {
  static const _storage = FlutterSecureStorage();

  // Method to securely store tokens
  static Future<void> _persistTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  // Method to get the access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  static Future<AuthResponse> register({required String username, required String email, required String password, required String confirmPassword, String firstName="", String lastName=""}) async {
    if (password != confirmPassword) {
      return AuthResponse.passwordConfirmNotMatching;
    }
    final url = Uri.https(ApiConstants.baseUrl, ApiConstants.appRegisterEndpoint);
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.apiHeader,
        body: jsonEncode({
          'username': username,
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'password': password,
        }),
      );
      if(response.statusCode == 201) {
        return AuthResponse.success;
      } else if (response.statusCode == 404) {
        return AuthResponse.invalidCredentials;
      } else if (response.statusCode == 400) {
        return AuthResponse.badRequest;
      } else {
        return AuthResponse.randomError;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Registration error: $e");
      }
      return AuthResponse.randomError;
    }
  }

  static Future<AuthResponse> login({required String username, required String password}) async {
    final url = Uri.https(ApiConstants.baseUrl, ApiConstants.appLoginEndpoint);
    try {
      final response = await http.post(
        url,
        headers: ApiConstants.apiHeader,
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _persistTokens(data['access'], data['refresh']);
        User? user = await getCurrentUser(username);
        if (user == null) {
          if (kDebugMode) {
            print("Login error: Could not retrieve user data from backend!");
          }
          logout();
          return AuthResponse.randomError;
        }

        HiveService().upsertUserInBox(user);

        // On successful login, parse and store the tokens

        return AuthResponse.success;
      } else if (response.statusCode == 404) {
        if (kDebugMode) {
          print("Login error: $AuthResponse.randomError");
        }
        return AuthResponse.invalidCredentials;
      } else if (response.statusCode == 400) {
        if (kDebugMode) {
          print("Login error: $AuthResponse.randomError");
        }
        return AuthResponse.badRequest;
      } else {
        if (kDebugMode) {
          print("Login error: $AuthResponse.randomError");
        }
        return AuthResponse.randomError;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Login error: $e");
      }
      return AuthResponse.randomError;
    }
  }

  static Future<User?> getCurrentUser(String username) async {
    final token = await getAccessToken();
    if (token == null) {
      return null; // Not authenticated
    }

    final url = Uri.https(ApiConstants.baseUrl, "${ApiConstants.appGetCurrentUserEndpoint}/$username");
    try {
      final response = await http.get(
        url,
        headers: ApiConstants.apiHeader
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON and return the AppUser object
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        // If the request fails, return null
        if (kDebugMode) {
          print("Error fetching user data: ${response.statusCode}");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user data: $e");
      }
    }
    return null;
  }

  static Future<User?> updateCurrentUser(User user) async {
    final token = await getAccessToken();
    if (token == null) {
      return null; // Not authenticated
    }

    final url = Uri.https(ApiConstants.baseUrl, "${ApiConstants.appGetCurrentUserEndpoint}/${user.username}");
    try {
      final response = await http.put(
          url,
          headers: ApiConstants.apiHeader,
          body: jsonEncode(user.toJson())
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON and return the AppUser object
        final data = jsonDecode(response.body);
        var newUser = User.fromJson(data);
        HiveService().upsertUserInBox(newUser);
        return newUser;
      } else {
        // If the request fails, return null
        if (kDebugMode) {
          print("Error updating user data: ${response.statusCode}");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating user data: $e");
      }
    }
    return null;
  }

  static Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null;
  }

  static Future<void> logout() async {
    await HiveService().logoutUser();
    await _storage.deleteAll();
  }

  static Future<void> deleteAccount(var context) async {
    final user = HiveService().getUser()!;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
            child: CircularProgressIndicator(color: placeholderTextColor)));
    try {
      var response = await http.delete(
        Uri.https(ApiConstants.baseUrl, "${ApiConstants.appDeleteCurrentUserEndpoint}/${user.username}"),
        headers: ApiConstants.apiHeader,
        body: jsonEncode(user.toJson())
      );
      if (response.statusCode == 200) {
        snackText = 'Account successfully deleted!';
        await logout();
        if (kDebugMode) {
          print('Account successfully deleted!');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    snackText = 'Account successfully deleted!';
    if (kDebugMode) {
      print('Account successfully deleted!');
    }
  }

  static Widget initialRouting(WidgetRef ref) {
    var user = HiveService().getUser();
    if (user == null) {
      return LoginPage();
    } else {
      return const HomePage();
      //}
    }
  }
}
