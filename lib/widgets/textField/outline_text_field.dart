import 'package:flutter/material.dart';
import 'package:smart/utils/colors.dart';

import '../../utils/fonts.dart';

class OutLineTextField extends StatelessWidget {
  final double width;
  final double height;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final bool obscureText;
  final int maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChange;

  const OutLineTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.width = 290,
    this.height = 50,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyBoardType = TextInputType.text,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: TextFormField(
        maxLines: maxLines,
        maxLength: maxLength,
        onChanged: onChange ?? (value) {},
        style: AppTypography.font16black.copyWith(fontSize: 15),
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            borderSide: BorderSide(
              width: 2,
              color: AppColors.whiteGray,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            borderSide: BorderSide(
              width: 2,
              color: AppColors.whiteGray,
            ),
          ),
        ),
        controller: controller,
      ),
    );
  }
}

