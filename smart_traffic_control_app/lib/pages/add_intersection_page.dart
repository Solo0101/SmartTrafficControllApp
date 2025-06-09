import 'package:flutter/material.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:smart_traffic_control_app/constants/router_constants.dart';

import '../components/my_appbar.dart';
import '../components/my_button.dart';
import '../components/my_drawer.dart';
import '../components/my_textfield.dart';
import '../constants/style_constants.dart';
import '../models/intersection.dart';
import '../services/api_service.dart';

class AddIntersectionPage extends StatefulWidget {
  const AddIntersectionPage({super.key});

  @override
  State<AddIntersectionPage> createState() => _AddIntersectionPageState();
}

class _AddIntersectionPageState extends State<AddIntersectionPage> {
  final intersectionNameController = TextEditingController();
  final intersectionAddressController = TextEditingController();
  final intersectionCountryController = TextEditingController();
  final intersectionCityController = TextEditingController();
  final intersectionCoordinatesLatController = TextEditingController();
  final intersectionCoordinatesLongController = TextEditingController();
  final intersectionEntriesNumberController = TextEditingController();
  final intersectionIndividualToggleController = TextEditingController(text: "false");
  final intersectionSmartAlgorithmToggleController = TextEditingController(text: "true");

  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const MyDrawer(),
        appBar: const MyAppBar(
          title: 'Add new intersection',
          hasBackButton: true,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              Form(
                child: Column(children: <Widget>[
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
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    const Text("Individual entries traffic light toggle",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: primaryTextColor,
                        )),
                    Checkbox(
                        semanticLabel: "Individual entry traffic light toggle",
                        checkColor: Colors.white,
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          return utilityButtonColor;
                        }),
                        value: bool.parse(intersectionIndividualToggleController.text),
                        onChanged: (bool? value) {
                          setState(() {
                            intersectionIndividualToggleController.text = value!.toString();
                          });
                        }),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    const Text("Smart Algorithm toggle",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: primaryTextColor,
                        )),
                    Checkbox(
                        semanticLabel: "Smart Algorithm toggle",
                        checkColor: Colors.white,
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          return utilityButtonColor;
                        }),
                        value: bool.parse(intersectionSmartAlgorithmToggleController.text),
                        onChanged: (bool? value) {
                          setState(() {
                            intersectionSmartAlgorithmToggleController.text = value!.toString();
                          });
                        }),
                  ]),
                  MyButton(
                      buttonColor: addGreenButtonColor,
                      textColor: primaryTextColor,
                      buttonText: _isSaving ? "Saving..." : "Save",
                      onPressed: _isSaving ? null : () async {
                        if (intersectionNameController.text.isEmpty /* || other validations */) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all required fields.', style: TextStyle(color: primaryTextColor)),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _isSaving = true;
                        });

                        showDialog(
                          context: context,
                          barrierDismissible: false, // User cannot dismiss it
                          builder: (BuildContext context) {
                            return const Center(child: CircularProgressIndicator(color: utilityButtonColor));
                          },
                        );

                        try {
                          Map<String, int> entriesTrafficScore = {};
                          for (int i = 0; i < int.parse(
                              intersectionEntriesNumberController.text); i++) {
                            entriesTrafficScore.update(
                                'entry$i', (value) => 0, ifAbsent: () => 0);
                          }
                          Intersection newIntersection = Intersection(
                              id: "",
                              name: intersectionNameController.text,
                              address: intersectionAddressController.text,
                              coordinates: GeoJSONPoint([
                                double.parse(
                                    intersectionCoordinatesLongController.text),
                                double.parse(
                                    intersectionCoordinatesLatController.text)
                              ]),
                              country: intersectionCountryController.text,
                              city: intersectionCityController.text,
                              entriesNumber: int.parse(
                                  intersectionEntriesNumberController.text),
                              individualToggle: bool.parse(
                                  intersectionIndividualToggleController.text),
                              smartAlgorithmEnabled: bool.parse(
                                  intersectionSmartAlgorithmToggleController
                                      .text),
                              entries: const []
                          );

                          await ApiService.addIntersection(newIntersection);

                          if (context.mounted) Navigator.of(context, rootNavigator: true).pop(); // Dismiss loading dialog
                          if (context.mounted) Navigator.pushReplacementNamed(context, homePageRoute);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Intersection added successfully!',
                                    style: TextStyle(color: primaryTextColor)),
                                backgroundColor: Colors.green,
                              ),
                            );
                        }


                        } catch (e) {
                          if (context.mounted) Navigator.of(context, rootNavigator: true).pop(); // Dismiss loading dialog on error

                          // Show error SnackBar
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error adding intersection: $e', style: const TextStyle(color: primaryTextColor)),
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
                ]),
              )
            ]))));
  }
}
