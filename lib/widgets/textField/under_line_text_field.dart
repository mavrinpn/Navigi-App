import 'package:flutter/material.dart';
import 'package:smart/utils/colors.dart';

import '../../utils/fonts.dart';

class UnderLineTextField extends StatelessWidget {
  final double width;
  final double height;
  final int? maxLength;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final bool obscureText;
  final ValueChanged<String>? onChange;
  final VoidCallback? onEditingComplete;
  final Function(dynamic)? onTapOutside;
  final String suffixIcon;
  final String? Function(String?)? validator;
  final bool error;

  const UnderLineTextField(
      {Key? key,
      required this.hintText,
      required this.controller,
      this.maxLength,
      this.width = 290,
      this.height = 50,
      this.obscureText = false,
      this.keyBoardType = TextInputType.phone,
      required this.onChange,
      this.onEditingComplete,
      this.onTapOutside,
      this.validator,
      required this.suffixIcon,
      this.error = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.bottomCenter,
      child: TextFormField(
        maxLength: maxLength,
        validator: validator,
        onTap: () => controller.selection = TextSelection(
            baseOffset: 0, extentOffset: controller.value.text.length),
        onTapOutside: onTapOutside,
        keyboardType: keyBoardType,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.bottom,
        onChanged: onChange,
        onEditingComplete: onEditingComplete,
        style: AppTypography.font16black,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.font14lightGray,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: error ? AppColors.red : AppColors.whiteGray,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: error ? AppColors.red : AppColors.whiteGray,
              ),
            ),
            suffixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  suffixIcon,
                  style: AppTypography.font14lightGray.copyWith(fontSize: 16),
                ),
              ],
            )),
        controller: controller,
      ),
    );
  }
}
