import 'package:flutter/material.dart';
import 'package:smart/utils/colors.dart';

class PopularQueryItem extends StatelessWidget {
  const PopularQueryItem({super.key, required this.onTap, required this.name});

  final VoidCallback onTap;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: onTap,
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.backgroundLightGray,
            ),
            child: Text(name)),
      ),
    );
  }
}
