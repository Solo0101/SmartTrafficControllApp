import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_traffic_control_app/components/my_button.dart';
import 'package:smart_traffic_control_app/services/database_service.dart';

import '../components/my_appbar.dart';
import '../components/my_drawer.dart';
import '../constants/style_constants.dart';
import '../models/intersection.dart';

class IntersectionPage extends StatefulWidget {
  final Intersection intersection;

  const IntersectionPage({super.key, required this.intersection});

  @override
  State<IntersectionPage> createState() => _IntersectionPageState();
}

class _IntersectionPageState extends State<IntersectionPage> {
  int currentPageIndex = 0;
  late List<PolyEditor> polyEditor;

  List<Polyline> polylines = [];
  int polylinesCounter = 0;
  FlutterMapMath mapCalculator = FlutterMapMath();

  @override
  void initState() {
    super.initState();
    if (widget.intersection.entriesCoordinates!.isEmpty) {
      polylines = List.generate(widget.intersection.entriesNumber, (index) => Polyline(points: [], color: Colors.green, strokeWidth: 15.0));
    } else {
      List<LatLng> tempPoints = [];
      var tempList = [];

      for (var i = 0; i < widget.intersection.entriesNumber; i++) {
        tempPoints = [];
        for (var j = 0; j < widget.intersection.entriesCoordinates!["entrieNumber$i"]!.length; j++) {
          tempPoints.add(LatLng(widget.intersection.entriesCoordinates!["entrieNumber$i"]![j].latitude, widget.intersection.entriesCoordinates!["entrieNumber$i"]![j].longitude));
        }

        tempList.add(Polyline(points: tempPoints, color: getEntrieColor(widget.intersection.entriesTrafficScore!["entrieNumber$i"]!), strokeWidth: 15.0));
      }

      polylines = List.generate(widget.intersection.entriesNumber,
          (index) => Polyline(points: tempList[index].points, color: getEntrieColor(widget.intersection.entriesTrafficScore!["entrieNumber$index"]!), strokeWidth: 15.0));
    }
    polyEditor = List.generate(
        widget.intersection.entriesNumber,
        (index) => PolyEditor(
              points: polylines[index].points,
              pointIcon: const Icon(Icons.crop_square, size: 23),
              // intermediateIcon: const Icon(Icons.lens, size: 15, color: Colors.grey),
              callbackRefresh: (_) => {setState(() {})},
              addClosePathMarker: false, // set to true if polygon
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MyDrawer(),
      appBar: const MyAppBar(
        title: 'Intersection details',
        hasBackButton: true,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
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
            icon: Icon(Icons.admin_panel_settings_rounded, color: primaryTextColor),
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
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              SizedBox(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: FlutterMap(
                    options: MapOptions(
                        interactionOptions: const InteractionOptions(
                          flags: ~InteractiveFlag.pinchZoom &
                              ~InteractiveFlag.doubleTapZoom &
                              ~InteractiveFlag.drag &
                              ~InteractiveFlag.pinchMove &
                              ~InteractiveFlag.rotate &
                              ~InteractiveFlag.flingAnimation,
                        ),
                        initialCenter: LatLng(widget.intersection.coordinates.latitude, widget.intersection.coordinates.longitude),
                        initialZoom: 17.0,
                        keepAlive: true,
                        onTap: (tapPosition, ll) {
                          // TODO: add popup on map polyline click
                        }),
                    children: [
                      TileLayer(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
                      // if (data.isNotEmpty)
                      PolylineLayer(
                        polylines: polylines,
                      ),
                    ]),
              ),
            ]),
          ),
        ),

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
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              SizedBox(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: FlutterMap(
                    options: MapOptions(
                        interactionOptions: const InteractionOptions(
                          flags: ~InteractiveFlag.pinchZoom &
                              ~InteractiveFlag.doubleTapZoom &
                              ~InteractiveFlag.drag &
                              ~InteractiveFlag.pinchMove &
                              ~InteractiveFlag.rotate &
                              ~InteractiveFlag.flingAnimation,
                        ),
                        initialCenter: LatLng(widget.intersection.coordinates.latitude, widget.intersection.coordinates.longitude),
                        initialZoom: 17.0,
                        keepAlive: true,
                        onTap: (tapPosition, ll) {
                          polyEditor[polylinesCounter].add(polylines[polylinesCounter].points, ll);

                          if (!(polylines[polylinesCounter].points.length < 2)) {
                            if (polylinesCounter < widget.intersection.entriesNumber - 1) {
                              polylinesCounter++;
                            } else {
                              polylinesCounter = 0;
                            }
                          }
                        },
                        onLongPress: (tapPosition, ll) {
                          var indexPolyline = 0;
                          bool found = false;
                          for (var polyline in polylines) {
                            for (var point in polyline.points) {
                              if (mapCalculator.distanceBetween(ll.latitude, ll.longitude, point.latitude, point.longitude, "meter") < 0.0001) {
                                polyline.points.remove(point);
                                polylinesCounter = indexPolyline;
                                found = true;
                                break;
                              }
                            }

                            if (polyline.points.length < 2) {
                              polylinesCounter = indexPolyline;
                              found = true;
                              break;
                            }

                            if (!found) {
                              indexPolyline++;
                            }
                          }
                        }),
                    children: [
                      TileLayer(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
                      // if (data.isNotEmpty)
                      PolylineLayer(
                        polylines: polylines,
                      ),
                      for (var i = 0; i < widget.intersection.entriesNumber; i++) DragMarkers(markers: polyEditor[i].edit())

                      // DragMarkers(markers: polyEditor[polylinesCounter].edit()),
                    ]),
              ),
              MyButton(
                  buttonColor: addGreenButtonColor,
                  textColor: primaryTextColor,
                  buttonText: "Save",
                  onPressed: () async {
                    var indexPolyline = 0;
                    var indexPoint = 0;
                    for (var polyline in polylines) {
                      List<GeoPoint> tempList = [];
                      for (var point in polyline.points) {
                        tempList.add(GeoPoint(point.latitude, point.longitude));
                        indexPoint++;
                      }
                      widget.intersection.entriesCoordinates?.update("entrieNumber$indexPolyline", (value) => tempList, ifAbsent: () => tempList);
                      indexPolyline++;
                    }
                    await DatabaseService.editIntersectionById(widget.intersection.id, widget.intersection);
                  }),
            ]),
          ),
        ),
      ][currentPageIndex],
    );
  }

  Color getEntrieColor(int trafficScore) {
    if (trafficScore < 30) {
      return Colors.green;
    } else if (trafficScore < 70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
