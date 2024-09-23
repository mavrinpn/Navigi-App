import 'package:flutter/material.dart';
import 'package:smart/utils/fonts.dart';

import '../../utils/colors.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final double width;
  final double height;
  final TextStyle styleText;
  final EdgeInsets padding;
  final bool active;
  final Color activeColor;
  final Color disableColor;
  final Widget? child;

  const CustomTextButton({
    Key? key,
    required this.callback,
    required this.text,
    required this.styleText,
    this.width = double.infinity,
    this.height = 50,
    this.padding = const EdgeInsets.all(0),
    this.active = false,
    this.child,
    this.activeColor = AppColors.red,
    this.disableColor = AppColors.buttonLightGray,
  }) : super(key: key);

  CustomTextButton.withIcon({
    Key? key,
    required this.callback,
    required this.text,
    required this.styleText,
    this.width = 1000,
    this.height = 52,
    this.padding = EdgeInsets.zero,
    this.active = false,
    this.activeColor = AppColors.red,
    this.disableColor = AppColors.buttonLightGray,
    required Widget icon,
  })  : child = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              text,
              style: styleText,
            )
          ],
        ),
        super(key: key);

  const CustomTextButton.orangeContinue({
    Key? key,
    required this.callback,
    required this.text,
    this.styleText = AppTypography.font14white,
    this.width = double.infinity,
    this.height = 52,
    this.padding = const EdgeInsets.all(0),
    this.active = false,
    this.child,
    this.activeColor = AppColors.red,
    this.disableColor = AppColors.buttonLightGray,
  }) : super(key: key);

  const CustomTextButton.shadow({
    Key? key,
    required this.callback,
    required this.text,
    this.styleText = AppTypography.font14white,
    this.width = double.infinity,
    this.height = 52,
    this.padding = const EdgeInsets.all(0),
    this.active = false,
    this.child,
    this.activeColor = AppColors.red,
    this.disableColor = AppColors.buttonLightGray,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            backgroundColor: active ? activeColor : disableColor,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14)))),
        onPressed: callback,
        child: child ??
            Text(
              text,
              style: styleText,
            ),
      ),
    );
  }
}
