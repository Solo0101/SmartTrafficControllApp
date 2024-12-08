import 'package:flutter/material.dart';
import 'package:smart_traffic_control_app/constants/style_constants.dart';

class MyButton extends StatelessWidget {
  final Color buttonColor;
  final Color textColor;
  final String buttonText;
  final void Function()? onPressed;
  final Color? borderColor;

  const MyButton(
      {super.key,
      required this.buttonColor,
      required this.textColor,
      required this.buttonText,
      required this.onPressed,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          minimumSize: const Size.fromHeight(40),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: borderColor ?? buttonColor, width: 0.5)),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 20, color: buttonTextColor),
        ),
      ),
    );

    //   Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     TextButton(
    //         onPressed: onPressed,
    //         child: Container(
    //           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    //           margin: const EdgeInsets.symmetric(horizontal: 10),
    //           decoration: BoxDecoration(
    //             color: buttonColor,
    //             borderRadius: BorderRadius.circular(8.0),
    //           ),
    //           child: Row(children: [
    //             Text(
    //               buttonText,
    //               style:
    //                   const TextStyle(fontSize: 20.0, color: buttonTextColor),
    //             )
    //           ]),
    //         )),
    //   ],
    // );
  }
}
