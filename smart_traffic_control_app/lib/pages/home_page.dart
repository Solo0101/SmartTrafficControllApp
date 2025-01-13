import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_traffic_control_app/components/my_appbar.dart';
import 'package:smart_traffic_control_app/components/my_button.dart';
import 'package:smart_traffic_control_app/components/my_card.dart';
import 'package:smart_traffic_control_app/constants/style_constants.dart';

import '../components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // setState(() {
    //   showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (context) {
    //       return const Center(
    //         child: CircularProgressIndicator(color: utilityButtonColor),
    //       );
    //     },
    //   );
    //   if (context.mounted) Navigator.of(context).pop();
    //   await DatabaseService.fetchIntersections();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const MyAppBar(
        title: 'Main dashboard',
      ),
      endDrawer: const MyDrawer(),
      body: Container(
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * topContainerPercentage,
              child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(35.0, 30.0, 0.0, 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Select an intersection:',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: primaryTextColor,
                          )),
                    ],
                  ),
                ),
              ]),
            ),
            StreamBuilder<QuerySnapshot>(
                // <2> Pass `Stream<QuerySnapshot>` to stream
                stream: FirebaseFirestore.instance.collection('intersections').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> documents = snapshot.data!.docs;
                    return ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: documents
                            .map((doc) => MyCard(
                                  id: doc.id,
                                  name: doc['name'],
                                  address: doc['address'],
                                  coordinates: doc['coordXY'],
                                  country: doc['country'],
                                  city: doc['city'],
                                ))
                            .toList());
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: utilityButtonColor));
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: Text('No intersections added at the moment!', style: TextStyle(color: primaryTextColor)),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return const Center(
                    child: Text('No intersections added at the moment!', style: TextStyle(color: primaryTextColor)),
                  );
                }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: MyButton(buttonColor: addGreenButtonColor, textColor: primaryTextColor, buttonText: "Add Intersection", onPressed: () {}),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
