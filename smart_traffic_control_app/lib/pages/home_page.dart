import 'package:flutter/material.dart';
import 'package:smart_traffic_control_app/components/my_appbar.dart';
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
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            // Container(
            //   height: MediaQuery.of(context).size.height *
            //       topContainerPercentage /
            //       2,
            //   color: primaryHeaderColor,
            //   child: const Center(
            //     child: SafeArea(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text('Main dashboard',
            //               style: TextStyle(
            //                   fontSize: 25.0,
            //                   color: primaryTextColor,
            //                   fontWeight: FontWeight.bold)),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            SizedBox(
              height: MediaQuery.of(context).size.height *
                  (1 - topContainerPercentage),
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
          ],
        ),
      ),
    );
  }
}
