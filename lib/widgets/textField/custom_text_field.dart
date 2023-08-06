// Flutter imports:
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/utils/colors.dart';

// Project imports:
import '../../utils/fonts.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    required this.prefIcon,
    required this.onChanged,
    this.height = 80,
    this.width = double.infinity,
    this.obscureText = false,
    this.validator,
    this.hintText = '',
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType keyboardType;
  final double height;
  final double width;
  final bool obscureText;
  final String prefIcon;
  final FormFieldValidator<String>? validator;
  final void Function(String?) onChanged;
  final String hintText;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            validator: widget.validator,
            maxLines: 1,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: widget.hintText,
              isDense: true,
              fillColor: AppColors.empty,
              hintStyle: AppTypography.font17black.copyWith(color: AppColors.whiteGray),
              filled: true,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.lightGray,
                  width: 1.0,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        widget.prefIcon,
                        width: 24,
                        height: 24,
                        color: AppColors.black,
                      ),
                      const SizedBox(
                        height: 6,
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    SvgPicture.asset('Assets/icons/line.svg',
                        color: AppColors.lightGray),
                    const SizedBox(
                      height: 4,
                    )
                  ]),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
            style: AppTypography.font17black,
            onChanged: widget.onChanged,
            controller: widget.controller,
          )),
    );
  }
}
