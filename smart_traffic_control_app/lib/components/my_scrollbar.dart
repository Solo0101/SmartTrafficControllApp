import 'package:flutter/material.dart';

class MyScrollbar extends Scrollbar {
  const MyScrollbar({super.key, required super.child})
      : super(
          thickness: 5.0,
          thumbVisibility: true,
          radius: const Radius.circular(20.0),
        );
}
