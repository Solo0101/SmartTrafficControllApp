import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_traffic_control_app/constants/style_constants.dart';

class MyTextField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String hintText;
  late bool obscureText;
  final bool isPassword;
  final bool hasValidation;

  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.isPassword = false,
    this.hasValidation = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends ConsumerState<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (widget.hasValidation) {
              if (value == null || value.isEmpty) {
                return 'This field is required!';
              }
            }
            return null;
          },
          style: const TextStyle(color: primaryTextColor),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                // borderSide: const BorderSide(color: Colors.grey)
              ),
              helperStyle: const TextStyle(color: primaryTextColor),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                // borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              fillColor: primaryOverlayBackgroundColor,
              filled: true,
              hintText: widget.hintText,
              hintStyle:
                  const TextStyle(color: placeholderTextColor, fontSize: 15.0),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                          widget.obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: primaryTextColor),
                      onPressed: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText;
                        });
                      },
                    )
                  : null),
        ),
      ),
    );
  }
}
