import 'package:flutter/material.dart';
import 'package:smart/utils/colors.dart';

class ImagesIndicators extends StatelessWidget {
  const ImagesIndicators({super.key, required this.length, required this.currentIndex, this.size = 5});

  final int length;
  final int currentIndex;
  final double size;

  List<Widget> indicators(imagesLength, currentIndex, {double size = 5}) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: const EdgeInsets.all(5),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: currentIndex == index ? AppColors.red : AppColors.whiteGray,
          shape: BoxShape.circle,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators(length, currentIndex, size: size),
    );
  }
}
