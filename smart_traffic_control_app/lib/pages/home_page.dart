import 'package:flutter/material.dart';
import 'package:smart_traffic_control_app/components/my_appbar.dart';
import 'package:smart_traffic_control_app/components/my_button.dart';
import 'package:smart_traffic_control_app/components/my_card.dart';
import 'package:smart_traffic_control_app/constants/style_constants.dart';

import '../components/my_drawer.dart';
import '../components/my_scrollbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const MyAppBar(
        title: 'Main dashboard',
      ),
      endDrawer: const MyDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            SizedBox(
              height:
                  MediaQuery.of(context).size.height * topContainerPercentage,
              child: const MyScrollbar(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
              ),
            ),
            const MyCard(
                id: '1',
                name: 'Intersection 1',
                address: 'Street 1, Number 1, Address 1'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: MyButton(
                      buttonColor: Colors.green,
                      textColor: primaryTextColor,
                      buttonText: "Add Intersection",
                      onPressed: () {}),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
