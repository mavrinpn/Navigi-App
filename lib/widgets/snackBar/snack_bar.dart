import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/utils/fonts.dart';

import '../../utils/colors.dart';

abstract class CustomSnackBar {
  static void showSnackBarWithIcon(
      BuildContext context, String text, String icon) {
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
                SvgPicture.asset(
                  icon,
                  width: 20,
                  height: 16,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Text(text,
              textAlign: TextAlign.center, style: AppTypography.font14white),
        ],
      ),
      backgroundColor: AppColors.dark,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarWithIcon);
  }

  static void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(text,
          textAlign: TextAlign.start, style: AppTypography.font14white),
      backgroundColor: AppColors.dark,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
