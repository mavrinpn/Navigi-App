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
  final ValueChanged<String>? onChange;

  const OutLineTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.width = 290,
    this.height = 50,
    this.obscureText = false,
    this.keyBoardType = TextInputType.text,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: TextFormField(
        onChanged: onChange,
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

