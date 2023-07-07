// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/colors.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback callback;
  final Color color;
  final String icon;

  const CustomIconButton({
    Key? key,
    required this.callback,
    required this.icon,
    this.color = AppColors.dark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: color,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)))),
        onPressed: callback,
        child: SvgPicture.asset(icon, width: 24, height: 24, color: Colors.white,),
      ),
    );
  }
}
