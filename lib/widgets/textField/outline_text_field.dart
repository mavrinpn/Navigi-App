// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/utils/colors.dart';

import '../../utils/fonts.dart';

class OutlineTextField extends StatelessWidget {
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
  final bool readonly;
  final bool error;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;

  const OutlineTextField({
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
    this.readonly = false,
    this.icon = "",
    this.error = false,
    this.focusNode,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: TextFormField(
        keyboardType: keyBoardType,
        readOnly: readonly,
        maxLines: maxLines,
        maxLength: maxLength,
        onChanged: onChange ?? (value) {},
        style: AppTypography.font16black.copyWith(fontSize: 15),
        textAlignVertical: TextAlignVertical.center,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          counterText: '',
          hintText: hintText,
          hintStyle: AppTypography.font14lightGray,
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
                      color: AppColors.lightGray,
                    ),
                  ],
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(13)),
            borderSide: BorderSide(
              width: 2,
              color: !error ? AppColors.whiteGray : AppColors.red,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(13)),
            borderSide: BorderSide(
              width: 2,
              color: !error ? AppColors.whiteGray : AppColors.red,
            ),
          ),
        ),
        controller: controller,
        focusNode: focusNode,
      ),
    );
  }
}
