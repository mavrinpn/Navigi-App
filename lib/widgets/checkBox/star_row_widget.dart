import 'package:flutter/material.dart';
import 'package:smart/utils/colors.dart';

class StarRowWidget extends StatelessWidget {
  const StarRowWidget({
    super.key,
    required this.score,
    required this.size,
    this.onTap,
  });

  final int score;
  final double size;
  final Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    final int points = score.toInt();
    return SizedBox(
      height: size,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onTap?.call(index),
            child: Icon(
              Icons.star,
              size: size,
              color: index < points ? AppColors.starsActive : AppColors.disable,
            ),
          );
        },
      ),
    );
  }
}
