import 'package:flutter/material.dart';
import 'package:smart_traffic_control_app/constants/router_constants.dart';
import 'package:smart_traffic_control_app/constants/style_constants.dart';

import '../services/hive_service.dart';
// import 'package:smart_traffic_control_app/services/hive_service.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      backgroundColor: popUpBackgroundColor,
      child: ListView(
        children: [
          const SizedBox(height: 100),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.home),
                SizedBox(
                  width: 10,
                ),
                Text("Home"),
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(homePageRoute);
            },
            titleTextStyle: const TextStyle(color: primaryTextColor),
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.person),
                SizedBox(
                  width: 10,
                ),
                Text("My Profile"),
              ],
            ),
            onTap: () {
              Navigator.of(context).pushNamed(myProfilePageRoute);
            },
            titleTextStyle: const TextStyle(color: primaryTextColor),
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.settings),
                SizedBox(
                  width: 10,
                ),
                Text("Settings"),
              ],
            ),
            onTap: () {
              Navigator.of(context).pushNamed(settingsPageRoute);
            },
            titleTextStyle: const TextStyle(color: primaryTextColor),
          ),
          const SizedBox(height: 100),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.output),
                SizedBox(
                  width: 10,
                ),
                Text("Sign Out"),
              ],
            ),
            onTap: () {
              HiveService().logoutUser();
              Navigator.of(context).pushReplacementNamed(loginPageRoute);
            },
            titleTextStyle: const TextStyle(color: primaryTextColor),
          ),
        ],
      ),
    );
  }
}
