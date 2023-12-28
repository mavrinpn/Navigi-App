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
    return InkWell(
        onTap: callback,
        child: Ink(
          width: 52,
          height: 52,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(14)),
              color: color),
          child: SvgPicture.asset(
            icon,
            color: Colors.white,
          ),
        ));
  }
}
