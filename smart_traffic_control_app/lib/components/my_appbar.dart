import 'package:flutter/material.dart';
import 'package:smart_traffic_control_app/constants/style_constants.dart';
import 'package:smart_traffic_control_app/constants/text_constants.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasBackButton;

  const MyAppBar({
    super.key,
    this.title = appTitle,
    this.hasBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    // return Row(children: [
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: primaryHeaderColor,
      foregroundColor: primaryTextColor,
      actions: const <Widget>[],
      leading: hasBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(),
            )
          : const SizedBox(),
    );
    // ]);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
