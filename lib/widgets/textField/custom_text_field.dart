// Flutter imports:
import 'package:flutter/material.dart';
import 'package:smart/utils/colors.dart';

// Project imports:

import '../../utils/fonts.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    required this.isError,
    required this.prefIcon,
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
  final bool isError;
  final String prefIcon;
  final FormFieldValidator<String>? validator;

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
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              isDense: true,
              fillColor: AppColors.empty,
              hintStyle: AppTypography.font17black,
              filled: true,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.lightGrayColors,
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
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.prefIcon),
                      )
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    '| ',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
            style: AppTypography.font17black,
            onChanged: (String value) {
              setState(() {});
            },
            controller: widget.controller,
          )),
    );
  }
}
