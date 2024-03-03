import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({
    super.key,
    required this.isActive,
    required this.onChanged,
  });

  final bool isActive;
  final VoidCallback onChanged;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: AppColors.empty,
      hoverColor: AppColors.empty,
      highlightColor: AppColors.empty,
      splashColor: AppColors.empty,
      onTap: widget.onChanged,
      child: CircleAvatar(
        backgroundColor: AppColors.empty,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: widget.isActive
                    ? AppColors.red
                    : AppColors.radioButtonGray),
            borderRadius: BorderRadius.circular(12),
          ),
          width: 22,
          height: 22,
          child: Container(
              padding: const EdgeInsets.all(4),
              child: CircleAvatar(
                radius: 5,
                backgroundColor:
                    widget.isActive ? AppColors.red : AppColors.empty,
              )),
        ),
      ),
    );
  }
}
