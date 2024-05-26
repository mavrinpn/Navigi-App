import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/utils/fonts.dart';

import '../../utils/colors.dart';

abstract class CustomSnackBar {
  static void showSnackBarWithIcon({
    required BuildContext context,
    required String text,
    String? iconAsset,
    IconData? iconData,
  }) {
    final snackBarWithIcon = SnackBar(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (iconAsset != null)
                  SvgPicture.asset(
                    iconAsset,
                    width: 20,
                    height: 16,
                  ),
                if (iconData != null)
                  Icon(
                    iconData,
                    size: 20,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(child: Text(text, textAlign: TextAlign.center, style: AppTypography.font14white)),
        ],
      ),
      backgroundColor: AppColors.dark,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarWithIcon);
  }

  static void showSnackBar(BuildContext context, String text, [int duration = 5]) {
    final snackBar = SnackBar(
      duration: Duration(seconds: duration),
      content: Text(text, textAlign: TextAlign.start, style: AppTypography.font14white),
      backgroundColor: AppColors.dark,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
