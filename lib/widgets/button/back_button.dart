import 'package:flutter/material.dart';
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
        Navigator.pop(context);
      },
      icon: const Icon(
        AppIcons.arrowleft,
        size: 18,
      ),
    );
    // return InkWell(
    //   focusColor: AppColors.empty,
    //   hoverColor: AppColors.empty,
    //   highlightColor: AppColors.empty,
    //   splashColor: AppColors.empty,
    //   onTap: () {
    //     if (callback != null) callback!();
    //     Navigator.pop(context);
    //   },
    //   child: SizedBox(
    //     width: 35,
    //     height: 48,
    //     child: Icon(
    //       Icons.arrow_back,
    //       color: color ?? AppColors.black,
    //     ),
    //   ),
    // );
  }
}
