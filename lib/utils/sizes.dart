import 'package:flutter/material.dart';

class AppSizes {
  static double anouncementGridSidePadding = 15.0;
  static double anouncementGridCrossSpacing = 15.0;
  static double anouncementGridMainSpacing = 4.0;
  static double anouncementAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - anouncementGridSidePadding * 2 - anouncementGridCrossSpacing) / 2;
    final itemHeight = itemWidth + 90;
    final ratio = itemWidth / itemHeight;
    return ratio;
  }

  static double anouncementRunSpacing = 15.0;
}
