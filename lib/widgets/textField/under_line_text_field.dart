import 'package:flutter/material.dart';
import 'package:smart/utils/colors.dart';

import '../../utils/fonts.dart';

class UnderLineTextField extends StatelessWidget {
  final double width;
  final double height;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final bool obscureText;
  final ValueChanged<String>? onChange;
  final String suffixIcon;

  const UnderLineTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.width = 290,
    this.height = 50,
    this.obscureText = false,
    this.keyBoardType = TextInputType.number,
    required this.onChange,
    required this.suffixIcon
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
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: AppColors.whiteGray,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: AppColors.whiteGray,
            ),
          ),
          suffixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                suffixIcon, style: AppTypography.font14lightGray.copyWith(fontSize: 16),
              ),
            ],
          )
        ),
        controller: controller,
      ),
    );
  }
}
