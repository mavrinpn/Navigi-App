import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart/utils/colors.dart';

class AppTheme {
  static final theme = ThemeData(
    primaryColor: AppColors.mainBackground,
    scaffoldBackgroundColor: AppColors.mainBackground,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.mainBackground, elevation: 0),
    fontFamily: GoogleFonts.nunito().fontFamily,
    chipTheme: const ChipThemeData(
      showCheckmark: false,
      selectedColor: Color(0xffED5434),
      backgroundColor: Color(0xffF4F5F6),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
  );
}
