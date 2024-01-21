import 'package:flutter/material.dart';
import 'package:smart/utils/fonts.dart';

class ItemParameterWidget extends StatelessWidget {
  const ItemParameterWidget(
      {super.key, required this.name, required this.currentValue});

  final String name;
  final String currentValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: AppTypography.font14lightGray,
          ),
          Text(
            currentValue,
            style:
                AppTypography.font14black.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
