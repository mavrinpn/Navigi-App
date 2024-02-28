// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/utils/fonts.dart';

import '../../utils/colors.dart';

class CustomElevatedButton extends StatefulWidget {
  const CustomElevatedButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onPress,
    required this.height,
    required this.width,
  });

  final double width;
  final double height;
  final String icon;
  final String title;
  final VoidCallback onPress;

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: widget.height,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 18,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: TextButton(
          onPressed: widget.onPress,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                widget.icon,
                width: 24,
                height: 24,
                color: AppColors.black,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.title,
                style: AppTypography.font14black
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ));
  }
}
