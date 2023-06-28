  import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final double width;
  final double height;
  final TextStyle styleText;
  final EdgeInsets padding;
  final bool isTouch;
  final Color activeColor;
  final Color disableColor;
  final Widget? child;

  const CustomElevatedButton({
    Key? key,
    required this.callback,
    required this.text,
    required this.styleText,
    this.width = double.infinity,
    this.height = 50,
    this.padding = const EdgeInsets.all(10),
    this.isTouch = false,
    this.child,
    this.activeColor = AppColors.isTouchButtonColorRed,
    this.disableColor = AppColors.isNotTouchButton,
  }) : super(key: key);

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
            elevation: 0,
            backgroundColor: isTouch ? activeColor : disableColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)))),
        onPressed: callback,
        child: child ?? Text(
          text,
          style: styleText,
        ),
      ),
    );
  }
}
