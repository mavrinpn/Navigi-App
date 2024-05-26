// Flutter imports:
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smart/main.dart';
import 'package:smart/utils/colors.dart';

// Project imports:

import '../../utils/fonts.dart';

class PhoneTextFormField extends StatefulWidget {
  const PhoneTextFormField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    required this.prefIcon,
    required this.mask,
    required this.onChanged,
    this.hintText = '',
    this.height = 80,
    this.width = double.infinity,
    this.obscureText = false,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType keyboardType;
  final double height;
  final double width;
  final bool obscureText;
  final String prefIcon;
  final FormFieldValidator<String>? validator;
  final MaskTextInputFormatter mask;
  final void Function(String?) onChanged;
  final String hintText;

  @override
  State<PhoneTextFormField> createState() => _PhoneTextFormFieldState();
}

class _PhoneTextFormFieldState extends State<PhoneTextFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            inputFormatters: [widget.mask],
            maxLines: 1,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textAlignVertical: TextAlignVertical.center,
            textDirection: TextDirection.ltr,
            textAlign: currentLocaleShortName.value == 'ar' ? TextAlign.end : TextAlign.start,
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hintText,
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
                        width: 20,
                        height: 20,
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
                    SvgPicture.asset('Assets/icons/line.svg', color: AppColors.lightGray),
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
