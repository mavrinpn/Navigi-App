import 'package:flutter/material.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/colors.dart';

class ImagePreparingWidget extends StatelessWidget {
  const ImagePreparingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      height: 98,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.backgroundLightGray,
      ),
      child: Center(child: AppAnimations.bouncingLine),
    );
  }
}
