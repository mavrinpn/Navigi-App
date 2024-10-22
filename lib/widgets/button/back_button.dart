import 'package:flutter/material.dart';
import 'package:smart/feature/main/ui/main_page.dart';
import 'package:smart/utils/app_icons_icons.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.callback, this.color});
  final VoidCallback? callback;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (callback != null) callback!();

        if (Navigator.of(context).canPop()) {
          Navigator.pop(context);
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
            (Route<dynamic> route) => false,
          );
        }
      },
      icon: Icon(
        AppIcons.arrowleft,
        size: 18,
        color: color ?? Colors.black,
      ),
    );
  }
}
