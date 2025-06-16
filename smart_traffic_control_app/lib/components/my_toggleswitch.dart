// my_toggleswitch.dart

import 'package:flutter/material.dart';
import 'package:smart_traffic_control_app/constants/style_constants.dart';
import '../services/api_service.dart';

class MyToggleSwitch extends StatelessWidget {
  final bool value; // Changed from initialValue
  final bool isSaving;
  final String label;
  final ValueChanged<bool> onChanged; // Add this callback
  final Future<void> Function() apiCallBuilder; // Use a function that returns a Future
  final String actionText1;
  final String actionText2;
  final String errorText1;
  final String errorText2;

  const MyToggleSwitch({
    super.key,
    required this.value, // Changed from initialValue
    required this.isSaving,
    required this.label,
    required this.onChanged, // Require the callback
    required this.apiCallBuilder,
    required this.actionText1,
    required this.actionText2,
    required this.errorText1,
    required this.errorText2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 18.0, color: primaryTextColor),
            ),
          ),
          Switch(
            value: value,
            activeColor: addGreenButtonColor,
            onChanged: isSaving
                ? null
                : (newValue) async {
              onChanged(newValue);
              await ApiService.onPressedApiCall(
                isSaving: isSaving,
                context: context,
                apiCall: apiCallBuilder(),
                setState: (fn) {},
                actionText: newValue ? actionText1 : actionText2,
                errorText: newValue ? errorText1 : errorText2,
              );
            },
          ),
        ],
      ),
    );
  }
}