import 'package:flutter/material.dart';

import '../constants/style_constants.dart';

class MyCard extends StatelessWidget {
  final String id;
  final String name;
  final String address;

  const MyCard(
      {super.key, required this.id, required this.name, required this.address});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {/* TODO: Add page redirect */},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
            color: primaryOverlayBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.traffic_rounded,
                      color: primaryTextColor),
                  // const Icon(Icons.traffic_outlined, color: primaryTextColor),
                  title: Text(name,
                      style: const TextStyle(color: primaryTextColor)),
                  subtitle: Text(address,
                      style: const TextStyle(color: placeholderTextColor)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {/* TODO: Add Google Maps Integration */},
                      icon: const Icon(Icons.pin_drop_rounded,
                          color: primaryTextColor),
                    ),
                    // const SizedBox(width: 8),
                    // TextButton(
                    //   child: const Text('LISTEN'),
                    //   onPressed: () {/* ... */},
                    // ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
