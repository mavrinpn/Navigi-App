import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({super.key, required this.isActive, required this.onChanged});
  final bool isActive;
  final ValueChanged<bool?>? onChanged;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.empty,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: AppColors.isTouchButtonColorRed),
          borderRadius: BorderRadius.circular(20),
        ),
        width: 30,
        height: 30,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Checkbox(
              checkColor: Colors.white,
              activeColor: AppColors.red,
              side: const BorderSide(width: 0, color: AppColors.empty),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              value: widget.isActive,
              onChanged: widget.onChanged),
        ),
      ),
    );
  }
}
