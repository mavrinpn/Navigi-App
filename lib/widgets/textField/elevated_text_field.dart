// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/utils/colors.dart';

import '../../utils/fonts.dart';

class ElevatedTextField extends StatelessWidget {
  final double width;
  final double height;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final bool obscureText;
  final int maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChange;
  final String icon;
  final VoidCallback onTap;

  const ElevatedTextField(
      {Key? key,
        required this.hintText,
        required this.controller,
        required this.onTap,
        this.width = 290,
        this.height = 50,
        this.obscureText = false,
        this.maxLines = 1,
        this.maxLength,
        this.keyBoardType = TextInputType.text,
        this.onChange,
        this.icon = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
      alignment: Alignment.center,
      child: TextFormField(
        onTap: onTap,
        maxLines: maxLines,
        maxLength: maxLength,
        onChanged: onChange ?? (value) {},
        style: AppTypography.font16black.copyWith(fontSize: 15),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTypography.font14lightGray.copyWith(color: AppColors.disable),
          prefixIcon: icon != ""
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 12,
              ),
              SvgPicture.asset(
                icon,
                width: 18,
                height: 18,
                color: AppColors.disable,
              ),
            ],
          )
              : null,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            borderSide: BorderSide(
              color: AppColors.empty,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            borderSide: BorderSide(
              color: AppColors.empty,
            ),
          ),
        ),
        controller: controller,
      ),
    );
  }
}
