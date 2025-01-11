import 'package:flutter/material.dart';

import '../components/my_appbar.dart';
import '../components/my_drawer.dart';
import '../constants/style_constants.dart';
import '../models/intersection.dart';
import '../services/database_service.dart';

class IntersectionPage extends StatefulWidget {
  final String intersectionId;
  const IntersectionPage({super.key, required this.intersectionId});

  @override
  State<IntersectionPage> createState() => _IntersectionPageState();
}

class _IntersectionPageState extends State<IntersectionPage> {
  int currentPageIndex = 0;

  late Intersection intersection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MyDrawer(),
      appBar: const MyAppBar(
        title: 'Intersection details',
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() async {
            currentPageIndex = index;
            if (index == 0) {
              intersection = await DatabaseService.fetchIntersectionById(
                  widget.intersectionId);
            }
          });
        },
        backgroundColor: backgroundColor,
        indicatorColor: primaryOverlayBackgroundColor,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.bar_chart_rounded, color: primaryTextColor),
            label: 'Statistics',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_rounded,
                color: primaryTextColor),
            label: 'Administration',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_road_rounded, color: primaryTextColor),
            label: 'Edit',
          ),
        ],
      ),
      body: <Widget>[
        /// Statistics page
        const Center(
            child:
                Text('Statistics', style: TextStyle(color: primaryTextColor))),

        /// Administration page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                'Administration',
                style: TextStyle(
                  fontSize: 20.0,
                  color: primaryTextColor,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),

        /// Edit intersection parameters page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                'Edit intersection parameters',
                style: TextStyle(
                  fontSize: 20.0,
                  color: primaryTextColor,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ][currentPageIndex],
    );
  }
}
