import 'package:flutter/material.dart';
import 'package:smart_traffic_control_app/constants/router_constants.dart';
import 'package:smart_traffic_control_app/pages/home_page.dart';
import 'package:smart_traffic_control_app/pages/login_page.dart';
import 'package:smart_traffic_control_app/pages/register_page.dart';

import '../pages/add_intersection_page.dart';
import 'package:smart_traffic_control_app/pages/profile_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPageRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case registerPageRoute:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case homePageRoute:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case addIntersectionPageRoute:
        return MaterialPageRoute(builder: (_) => const AddIntersectionPage());
      case myProfilePageRoute:
        return MaterialPageRoute(builder: (_) => const UserProfilePage());
      // case settingsPageRoute:
      //   return MaterialPageRoute(builder: (_) => const SettingsPage());

      ///Add new cases with routes HERE!!!!!!!

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error 404!'),
        ),
      );
    });
  }
}
