import 'dart:convert';

class ApiConstants {

  static const String baseUrl = 'smart-intersection.go.ro';
  static const String authString = "adrian:vadrian";

  static String encodedCredentials = base64.encode(utf8.encode(authString));

  static Map<String, String> apiHeader = {
  'Accept': '*/*',
  'Content-Type': 'application/json',
  'Authorization': 'Basic ${ApiConstants.encodedCredentials}'
  };

  static const String appRegisterEndpoint = 'auth/register/';
  static const String appLoginEndpoint = 'auth/token/';
  static const String appGetCurrentUserEndpoint = 'auth/me';
  static const String appDeleteCurrentUserEndpoint = 'auth/delete/me';

  static const String appGetStatisticsEndpoint = 'traffic_light/get/get_statistics';
  static const String appGetCurrentIntersectionStatusEndpoint = 'traffic_light/get/get_current_intersection_status';
  static const String appToggleTrafficLightsEndpoint = 'traffic_light/post/post_traffic_light_toggle';
  static const String appTrafficLightsAllRedEndpoint = 'traffic_light/post/post_traffic_light_all_red';
  static const String appTrafficLightsHazardModeEndpoint = 'traffic_light/post/post_traffic_light_hazard_mode';
  static const String appTurnOffTrafficLightsEndpoint = 'traffic_light/post/post_traffic_lights_off';
  static const String appResumeTrafficLightsEndpoint = 'traffic_light/post/post_traffic_light_resume';
  static const String appToggleSmartAlgorithmEndpoint = 'traffic_light/post/post_traffic_light_toggle_smart_algorithm';
  static const String appCreateIntersectionEndpoint = 'intersection/post/create_intersection';
  static const String appUpdateIntersectionEndpoint = 'intersection/put/update_intersection';
  static const String appGetIntersectionEndpoint = 'intersection/get/get_intersection';
  static const String appGetAllIntersectionsEndpoint = 'intersection/get/get_all_intersections';
  static const String appDeleteIntersectionEndpoint = 'intersection/delete/delete_intersection';

// TODO: Add more endpoints
}
