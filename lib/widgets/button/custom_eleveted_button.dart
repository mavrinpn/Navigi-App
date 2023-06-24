import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/fonts.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final double width;
  final double height;
  final TextStyle styleText;
  final EdgeInsets padding;
  final bool isTouch;

  const CustomElevatedButton(
      {Key? key,
        required this.callback,
        required this.text,
        required this.styleText,
        this.width = double.infinity,
        this.height = 50,
        this.padding = const EdgeInsets.all(10),
        this.isTouch = false,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: isTouch ? AppColors.isTouchButtonColor : AppColors.isNotTouchButtonColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)))),
        onPressed: callback,
        child: Text(
          text,
          style: styleText,
        ),
      ),
    );
  }
}
