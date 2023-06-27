import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';


class AppTypography {
  const AppTypography._();

  static const _colorBlack = AppColors.black;
  static const _lightGray = AppColors.lightGray;
  static const _white = Colors.white;
  static const _pink = AppColors.red;
  static final _font = GoogleFonts.nunito();
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
  static final font14white = _font.copyWith(
    color: _white,
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
  static final font16UnderLinePink = _font.copyWith(
    color: _pink,
    fontSize: 16,
    decoration: TextDecoration.underline,
  );
  static final font10pink = _font.copyWith(
    color: _pink,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
  );
  static final font10lightGray = _font.copyWith(
    color: _lightGray,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
  );
  static final font20black = _font.copyWith(
    color: _colorBlack,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );
}
