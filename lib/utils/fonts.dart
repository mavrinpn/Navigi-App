import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';


class AppTypography {
  const AppTypography._();

  static const _colorBlack = Colors.black;
  static const _lightGray = AppColors.lightGrayColors;
  static final _font = GoogleFonts.heebo();
  static final fontTheme = GoogleFonts.heeboTextTheme();

  static final font14black = _font.copyWith(
    color: _colorBlack,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: 14,
  );
  static final font24black = _font.copyWith(
    color: _colorBlack,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    fontSize: 24,
  );
  static final font14lightGray = _font.copyWith(
    color: _lightGray,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
  static final font17black = _font.copyWith(
    color: _colorBlack,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontSize: 17,
  );
}
