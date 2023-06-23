// Flutter imports:
import 'package:flutter/material.dart';
import 'package:smart/utils/colors.dart';

// Project imports:

import '../../utils/fonts.dart';

class PhoneTextFormField extends StatefulWidget {
  const PhoneTextFormField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    this.height = 80,
    this.width = double.infinity,
    this.padding = const EdgeInsets.all(10),
    this.maxLines = 1,
    this.hintText = '',
    this.obscureText = false,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType keyboardType;
  final double height;
  final double width;
  final EdgeInsets padding;
  final int maxLines;
  final String hintText;
  final bool obscureText;

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
        padding: widget.padding,
        child: TextFormField(
          maxLines: 1,
          keyboardType: widget.keyboardType,
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            fillColor: AppColors.empty,
            hintStyle: AppTypography.font17black,
            filled: true,
            hintText: widget.hintText,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                  color: AppColors.lightGrayColors,
                  width: 1.0,
                  style: BorderStyle.none
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
              ),
            ),
            prefix: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.phone_outlined,),
                SizedBox(width: 5,),
                Text('| ', style: TextStyle(fontSize: 25, color: AppColors.lightGrayColors),),
                SizedBox(width: 10,)
              ],
            ),
          ),
          style: AppTypography.font17black,
          onChanged: (String value) {
            setState(() {});
          },
          controller: widget.controller,
        ),
      ),
    );
  }
}
