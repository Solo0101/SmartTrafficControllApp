import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_traffic_control_app/constants/router_constants.dart';

import 'package:smart_traffic_control_app/services/api_service.dart';
import 'package:smart_traffic_control_app/models/intersection.dart';
import 'package:smart_traffic_control_app/components/my_button.dart';
import 'package:smart_traffic_control_app/components/my_textfield.dart';
import 'package:smart_traffic_control_app/components/my_appbar.dart';
import 'package:smart_traffic_control_app/components/my_chart.dart';
import 'package:smart_traffic_control_app/components/my_drawer.dart';
import 'package:smart_traffic_control_app/components/my_toggleswitch.dart';
import 'package:smart_traffic_control_app/constants/style_constants.dart';

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

  late Intersection _intersection;
  Timer? _dataFetchTimer;

  // State variables to hold the single latest data point for each chart
  LiveChartData? _latestWaitingTimePoint;
  LiveChartData? _latestThroughputPoint;

  // late bool initialTurnOnOffValue;
  // late bool initialToggleAllRedValue;
  // late bool initialToggleHazardModeValue;
  // late bool initialToggleSmartAlgorithmValue;
  late bool initialTurnOnOffValue = true;
  late bool initialToggleAllRedValue = false;
  late bool initialToggleHazardModeValue = false;
  late bool initialToggleSmartAlgorithmValue = true;

  late TextEditingController intersectionNameController;
  late TextEditingController intersectionCountryController;
  late TextEditingController intersectionCityController;
  late TextEditingController intersectionAddressController;
  late TextEditingController intersectionCoordinatesLatController;
  late TextEditingController intersectionCoordinatesLongController;
  late TextEditingController intersectionEntriesNumberController;
  late TextEditingController intersectionIndividualToggleController;
  late bool _isSaving;

  @override
  void initState() {
    super.initState();
    _intersection = widget.intersection;

    // Start fetching real-time data periodically
    _dataFetchTimer =
        Timer.periodic(const Duration(seconds: 5), (_) => _fetchRealtimeData());
    _fetchRealtimeData();

    // Initialize text controllers with data
    intersectionNameController =
        TextEditingController(text: _intersection.name);
    intersectionCountryController =
        TextEditingController(text: _intersection.country);
    intersectionCityController =
        TextEditingController(text: _intersection.city);
    intersectionAddressController =
        TextEditingController(text: _intersection.address);
    intersectionCoordinatesLatController = TextEditingController(
        text: _intersection.coordinates.coordinates.first.toString());
    intersectionCoordinatesLongController = TextEditingController(
        text: _intersection.coordinates.coordinates.last.toString());
    intersectionEntriesNumberController =
        TextEditingController(text: _intersection.entriesNumber.toString());
    intersectionIndividualToggleController =
        TextEditingController(text: _intersection.individualToggle.toString());

    _isSaving = false;

    _updatePolylines();

    polyEditor = List.generate(
        _intersection.entriesNumber,
        (index) => PolyEditor(
              points: polylines[index].points,
              pointIcon: const Icon(Icons.crop_square, size: 23),
              callbackRefresh: (_) => {setState(() {})},
              addClosePathMarker: false,
            ));
  }

  @override
  void dispose() {
    _dataFetchTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchRealtimeData() async {
    try {
      final newData = await ApiService.getStatistics(_intersection.id);
      if (!mounted) return;

      setState(() {
        _intersection.connectionStatus = newData.intersectionConnectionStatus
            ? ConnectionStatus.online
            : ConnectionStatus.offline;
        // Update the single latest data point state variables.
        // This will trigger didUpdateWidget in the MyChart widgets.
        if (_intersection.connectionStatus == ConnectionStatus.online &&
            (newData.avgWaitingTimeData.value != -1 ||
                newData.avgVehicleThroughputData.value != -1)) {
          _latestWaitingTimePoint = newData.avgWaitingTimeData;
          _latestThroughputPoint = newData.avgVehicleThroughputData;
        }

        newData.entryTrafficScores.forEach((key, score) {
          final entryNumber = int.tryParse(key.replaceFirst('entry', ''));
          if (entryNumber != null) {
            try {
              final entry = _intersection.entries
                  ?.firstWhere((e) => e.entryNumber == entryNumber);
              entry?.trafficScore = score;
            } catch (e) {
              // Entry not found
            }
          }
        });

        // _updatePolylines();
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      if (!mounted) return;
      setState(() {
        _intersection.connectionStatus = ConnectionStatus.offline;
      });
    }
  }

  Future<void> _fetchFullIntersection() async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));

      final response = await ApiService.fetchIntersection(_intersection.id);
      if (!mounted) return;
      Navigator.of(context).pop();

      if (response != null) {
        setState(() {
          // Replace the entire intersection object
          _intersection = response;
          // Clear the "latest point" variables so they aren't re-added
          _latestWaitingTimePoint = null;
          _latestThroughputPoint = null;
          // Re-initialize controllers and polylines with fresh data
          _updatePolylines();
          intersectionNameController.text = _intersection.name;
          intersectionAddressController.text = _intersection.address;
          intersectionCountryController.text = _intersection.country;
          intersectionCityController.text = _intersection.city;
          intersectionCoordinatesLatController.text =
              _intersection.coordinates.coordinates.first.toString();
          intersectionCoordinatesLongController.text =
              _intersection.coordinates.coordinates.last.toString();
          intersectionEntriesNumberController.text =
              _intersection.entriesNumber.toString();
          intersectionIndividualToggleController.text =
              _intersection.individualToggle.toString();
          _isSaving = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to refresh intersection data: $e")),
      );
    }
  }

  Future<void> _fetchCurrentIntersectionStatus() async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));

      final response = await ApiService.getCurrentStatus(_intersection.id);
      if (!mounted) return;
      Navigator.of(context).pop();

      setState(() {
        _intersection.connectionStatus = response["connected"]
            ? ConnectionStatus.online
            : ConnectionStatus.offline;
        _intersection.currentState = response["state"];

        switch (_intersection.currentState) {
          case "ALL_OFF":
            initialTurnOnOffValue = false;
            initialToggleAllRedValue = false;
            initialToggleHazardModeValue = false;
            break;
          case "ALL_RED":
            initialTurnOnOffValue = true;
            initialToggleAllRedValue = true;
            initialToggleHazardModeValue = false;
            break;
          case "HAZARD_MODE":
            initialTurnOnOffValue = true;
            initialToggleAllRedValue = false;
            initialToggleHazardModeValue = true;
            break;
          default:
            initialTurnOnOffValue = true;
            initialToggleAllRedValue = false;
            initialToggleHazardModeValue = false;
        }
        _isSaving = false;
      });
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to refresh intersection data: $e")),
      );
    }
  }

  void _updatePolylines() {
    if (_intersection.entries == null || _intersection.entries!.isEmpty) {
      polylines = List.generate(
          _intersection.entriesNumber,
          (index) =>
              Polyline(points: [], color: Colors.grey, strokeWidth: 15.0));
      return;
    }

    List<Polyline> newPolylines = [];
    for (var entry in _intersection.entries!) {
      List<LatLng> tempPoints = [];
      if (entry.coordinates1 != null &&
          entry.coordinates1!.coordinates.first != 0.0) {
        tempPoints.add(LatLng(entry.coordinates1!.coordinates.last,
            entry.coordinates1!.coordinates.first));
      }
      if (entry.coordinates2 != null &&
          entry.coordinates2!.coordinates.first != 0.0) {
        tempPoints.add(LatLng(entry.coordinates2!.coordinates.last,
            entry.coordinates2!.coordinates.first));
      }
      newPolylines.add(Polyline(
        points: tempPoints,
        color: getEntryColor(entry.trafficScore ?? 0),
        strokeWidth: 15.0,
      ));
    }
    polylines = newPolylines;
  }

  @override
  Widget build(BuildContext context) {
    Color statusBarColor;
    String statusText = '';

    switch (_intersection.connectionStatus) {
      case ConnectionStatus.online:
        statusBarColor = addGreenButtonColor;
        statusText = 'Online';
        break;
      case ConnectionStatus.offline:
        statusBarColor = importantButtonColor;
        statusText = 'Offline';
        break;
      case ConnectionStatus.unknown:
        statusBarColor = placeholderTextColor;
        statusText = 'Connecting...';
        break;
    }

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
            if (index == 0 && currentPageIndex != 0) {
              _fetchFullIntersection();
            }
            if (index == 1 && currentPageIndex != 1) {
              _fetchCurrentIntersectionStatus();
            }
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
        body: Column(children: <Widget>[
          Container(
            height: 25.0, // Small height for the bar
            width: double.infinity, // Full width
            color: statusBarColor,
            child: Center(
                child: Text(statusText,
                    style: const TextStyle(
                        color: primaryTextColor,
                        fontSize: 15))), // Optional text
          ),
          Expanded(
            child: <Widget>[
              /// Statistics page
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child:
                      Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
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
                              initialCenter: LatLng(
                                  widget.intersection.coordinates.coordinates
                                      .last,
                                  widget.intersection.coordinates.coordinates
                                      .first),
                              initialZoom: 17.0,
                              keepAlive: true,
                              onTap: (tapPosition, ll) {
                                // TODO: add popup on map polyline click
                              }),
                          children: [
                            TileLayer(
                                urlTemplate:
                                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
                            // if (data.isNotEmpty)
                            PolylineLayer(
                              polylines: polylines,
                            ),
                          ]),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: MyChart(
                            title: "Average Waiting Time",
                            initialChartData: _intersection
                                    .avgWaitingTimeDataPoints.isNotEmpty
                                ? _intersection.avgWaitingTimeDataPoints
                                : [],
                            currentChartDataPoint: _latestWaitingTimePoint)),
                    SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: MyChart(
                            title: "Average Vehicle Throughput",
                            initialChartData: _intersection
                                    .avgVehicleThroughputDataPoints.isNotEmpty
                                ? _intersection.avgVehicleThroughputDataPoints
                                : [],
                            currentChartDataPoint: _latestThroughputPoint)),
                    MyButton(
                        buttonColor: utilityButtonColor,
                        textColor: primaryTextColor,
                        buttonText: "Reset Statistics Data",
                        onPressed: _isSaving
                            ? null
                            : () async {
                                await ApiService.onPressedApiCall(
                                  isSaving: _isSaving,
                                  context: context,
                                  apiCall: ApiService.resetStatistics(
                                      _intersection.id),
                                  setState: setState,
                                  actionText: "Reset statistics data",
                                  errorText: 'resetting statistics data',
                                );
                                setState(() {
                                  _fetchFullIntersection();
                                });
                              })
                  ]),
                ),
              ),

              /// Administration page
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Column(
                      children: <Widget>[
                        MyToggleSwitch(
                          value: initialTurnOnOffValue,
                          isSaving: _isSaving,
                          label: "Turn ON/OFF Traffic Lights: ",
                          apiCallBuilder: () => ApiService.turnOffTrafficLights(
                              widget.intersection.id),
                          actionText1: "Turned traffic lights off",
                          actionText2: "Turned traffic lights on",
                          errorText1: "turning traffic lights off",
                          errorText2: "turning traffic lights on",
                          onChanged: (newValue) {
                            setState(() {
                              initialTurnOnOffValue = newValue;
                              initialToggleAllRedValue = false;
                              initialToggleHazardModeValue = false;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        MyButton(
                            buttonColor: utilityButtonColor,
                            textColor: primaryTextColor,
                            buttonText: "Toggle Color Change",
                            onPressed: _isSaving
                                ? null
                                : () async => await ApiService.onPressedApiCall(
                                    isSaving: _isSaving,
                                    context: context,
                                    apiCall: ApiService.toggleTrafficLights(
                                        widget.intersection.id),
                                    setState: setState,
                                    actionText: "Toggled color change",
                                    errorText: "toggling color change")),
                        const SizedBox(
                          height: 30.0,
                        ),
                        MyToggleSwitch(
                          value: initialToggleAllRedValue,
                          isSaving: _isSaving,
                          label: "Toggle All Red: ",
                          apiCallBuilder: () => ApiService.trafficLightsAllRed(
                              widget.intersection.id),
                          actionText1: "Toggled all traffic lights red",
                          actionText2: "Resumed traffic lights cycle",
                          errorText1: "toggling all traffic lights red",
                          errorText2: "resuming traffic lights cycle",
                          onChanged: (newValue) {
                            setState(() {
                              initialToggleAllRedValue = newValue;
                              initialTurnOnOffValue = true;
                              initialToggleHazardModeValue = false;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        MyToggleSwitch(
                          value: initialToggleHazardModeValue,
                          isSaving: _isSaving,
                          label: "Toggle Hazard Mode: ",
                          apiCallBuilder: () =>
                              ApiService.trafficLightsHazardMode(
                                  widget.intersection.id),
                          actionText1: "Toggled hazard mode",
                          actionText2: "Resumed traffic lights cycle",
                          errorText1: "toggling hazard mode",
                          errorText2: "resuming traffic lights cycle",
                          onChanged: (newValue) {
                            setState(() {
                              initialToggleHazardModeValue = newValue;
                              initialToggleAllRedValue = false;
                              initialTurnOnOffValue = true;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        MyToggleSwitch(
                          value: initialToggleSmartAlgorithmValue,
                          isSaving: _isSaving,
                          label: "Toggle Smart Algorithm: ",
                          apiCallBuilder: () => ApiService.toggleSmartAlgorithm(
                              widget.intersection.id),
                          actionText1: "Turned on smart algorithm",
                          actionText2: "Turned off smart algorithm",
                          errorText1: "toggling smart algorithm",
                          errorText2: "toggling smart algorithm",
                          onChanged: (newValue) {
                            setState(() {
                              initialToggleSmartAlgorithmValue = newValue;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Edit intersection parameters page
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child:
                      Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
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
                              initialCenter: LatLng(
                                  widget.intersection.coordinates.coordinates
                                      .first,
                                  widget.intersection.coordinates.coordinates
                                      .last),
                              initialZoom: 17.0,
                              keepAlive: true,
                              onTap: (tapPosition, ll) {
                                polyEditor[polylinesCounter].add(
                                    polylines[polylinesCounter].points, ll);

                                if (!(polylines[polylinesCounter]
                                        .points
                                        .length <
                                    2)) {
                                  if (polylinesCounter <
                                      widget.intersection.entriesNumber - 1) {
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
                                    if (mapCalculator.distanceBetween(
                                            ll.latitude,
                                            ll.longitude,
                                            point.latitude,
                                            point.longitude,
                                            "meter") <
                                        0.0001) {
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
                            TileLayer(
                                urlTemplate:
                                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
                            // if (data.isNotEmpty)
                            PolylineLayer(
                              polylines: polylines,
                            ),
                            for (var i = 0;
                                i < widget.intersection.entriesNumber;
                                i++)
                              DragMarkers(markers: polyEditor[i].edit())

                            // DragMarkers(markers: polyEditor[polylinesCounter].edit()),
                          ]),
                    ),
                    const SizedBox(height: 40),
                    Form(
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                          MyTextField(
                            controller: intersectionNameController,
                            hintText: "Intersection name",
                          ),
                          MyTextField(
                            controller: intersectionAddressController,
                            hintText: "Address",
                          ),
                          MyTextField(
                            controller: intersectionCountryController,
                            hintText: "Country",
                          ),
                          MyTextField(
                            controller: intersectionCityController,
                            hintText: "City",
                          ),
                          MyTextField(
                            controller: intersectionCoordinatesLatController,
                            hintText: "Latitude",
                          ),
                          MyTextField(
                            controller: intersectionCoordinatesLongController,
                            hintText: "Longitude",
                          ),
                          MyTextField(
                            controller: intersectionEntriesNumberController,
                            hintText: "Entries number",
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                    "Individual entries traffic light toggle",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: primaryTextColor,
                                    )),
                                Checkbox(
                                    semanticLabel:
                                        "Individual entry traffic light toggle",
                                    checkColor: Colors.white,
                                    fillColor: WidgetStateProperty.resolveWith(
                                        (states) {
                                      return utilityButtonColor;
                                    }),
                                    value: bool.parse(
                                        intersectionIndividualToggleController
                                            .text),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        intersectionIndividualToggleController
                                            .text = value!.toString();
                                      });
                                    }),
                              ]),
                          MyButton(
                              buttonColor: addGreenButtonColor,
                              textColor: primaryTextColor,
                              buttonText: _isSaving ? "Saving..." : "Save",
                              onPressed: _isSaving
                                  ? null
                                  : () async {
                                      setState(() {
                                        _isSaving = true;
                                      });

                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        // User cannot dismiss it
                                        builder: (BuildContext context) {
                                          return const Center(
                                              child: CircularProgressIndicator(
                                                  color: utilityButtonColor));
                                        },
                                      );

                                      try {
                                        var indexPolyline = 0;
                                        for (var polyline in polylines) {
                                          List<GeoJSONPoint> tempList = [];
                                          for (var point in polyline.points) {
                                            tempList.add(GeoJSONPoint([
                                              point.longitude,
                                              point.latitude
                                            ]));
                                          }
                                          widget
                                                  .intersection
                                                  .entries![indexPolyline]
                                                  .coordinates1
                                                  ?.coordinates =
                                              tempList[0].coordinates;
                                          widget
                                                  .intersection
                                                  .entries![indexPolyline]
                                                  .coordinates2
                                                  ?.coordinates =
                                              tempList[1].coordinates;
                                          indexPolyline++;
                                        }
                                        Intersection newIntersection =
                                            Intersection(
                                                id: widget.intersection.id,
                                                name: intersectionNameController
                                                    .text,
                                                address:
                                                    intersectionAddressController
                                                        .text,
                                                coordinates: GeoJSONPoint([
                                                  double.parse(
                                                      intersectionCoordinatesLatController
                                                          .text),
                                                  double.parse(
                                                      intersectionCoordinatesLongController
                                                          .text)
                                                ]),
                                                country:
                                                    intersectionCountryController
                                                        .text,
                                                city: intersectionCityController
                                                    .text,
                                                entriesNumber: int.parse(
                                                    intersectionEntriesNumberController
                                                        .text),
                                                individualToggle: bool.parse(
                                                    intersectionIndividualToggleController
                                                        .text),
                                                smartAlgorithmEnabled: true,
                                                entries: widget
                                                    .intersection.entries);
                                        await ApiService.updateIntersection(
                                            newIntersection);

                                        if (context.mounted) {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        }
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Intersection edited successfully!',
                                                  style: TextStyle(
                                                      color: primaryTextColor)),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(); // Dismiss loading dialog on error
                                        }
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Error editing intersection: $e',
                                                  style: const TextStyle(
                                                      color: primaryTextColor)),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      } finally {
                                        if (context.mounted) {
                                          setState(() {
                                            _isSaving = false; // End loading
                                          });
                                        }
                                      }
                                    }),
                          MyButton(
                              buttonColor: importantButtonColor,
                              textColor: primaryTextColor,
                              buttonText: _isSaving
                                  ? 'Deleting...'
                                  : "Delete Intersection",
                              onPressed: _isSaving
                                  ? null
                                  : () async {
                                      await ApiService.onPressedApiCall(
                                          isSaving: _isSaving,
                                          context: context,
                                          apiCall:
                                              ApiService.deleteIntersection(
                                                  widget.intersection.id),
                                          setState: setState,
                                          actionText: "Intersection deleted",
                                          errorText: "deleting intersection");
                                      if (context.mounted) {
                                        Navigator.pushReplacementNamed(
                                            context, homePageRoute);
                                      }
                                    })
                        ])),
                  ]),
                ),
              ),
            ][currentPageIndex],
          ),
        ]));
  }

  Color getEntryColor(int trafficScore) {
    if (trafficScore < 1) {
      return Colors.green;
    } else if (trafficScore < 5) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
