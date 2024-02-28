import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/utils/colors.dart';

class CustomIconButtonSearch extends StatelessWidget {
  const CustomIconButtonSearch(
      {super.key,
      required this.assetName,
      required this.callback,
      required this.height,
      required this.width});

  final VoidCallback callback;
  final String assetName;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: callback,
          child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
                color: AppColors.dark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Center(
              child: SvgPicture.asset(
                assetName,
                colorFilter: const ColorFilter.mode(
                  AppColors.mainBackground,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
