import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_traffic_control_app/constants/router_constants.dart';

import '../components/my_appbar.dart';
import '../components/my_button.dart';
import '../components/my_drawer.dart';
import '../components/my_textfield.dart';
import '../constants/style_constants.dart';
import '../models/intersection.dart';
import '../services/database_service.dart';

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
                        semanticLabel: "Individual entrie traffic light toggle",
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
                  MyButton(
                      buttonColor: addGreenButtonColor,
                      textColor: primaryTextColor,
                      buttonText: "Save",
                      onPressed: () async {
                        Map<String, int> entriesTrafficScore = {};
                        for (int i = 0; i < int.parse(intersectionEntriesNumberController.text); i++) {
                          entriesTrafficScore.update('entry$i', (value) => 0, ifAbsent: () => 0);
                        }
                        Intersection newIntersection = Intersection(
                            id: '0',
                            name: intersectionNameController.text,
                            address: intersectionAddressController.text,
                            coordinates: GeoPoint(double.parse(intersectionCoordinatesLatController.text), double.parse(intersectionCoordinatesLongController.text)),
                            country: intersectionCountryController.text,
                            city: intersectionCityController.text,
                            entriesNumber: int.parse(intersectionEntriesNumberController.text),
                            individualToggle: bool.parse(intersectionIndividualToggleController.text),
                            entriesCoordinates: {},
                            entriesTrafficScore: entriesTrafficScore);

                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(color: utilityButtonColor),
                            );
                          },
                        );
                        await DatabaseService.addIntersection(newIntersection);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, homePageRoute);
                        }
                      }),
                ]),
              )
            ]))));
  }
}
