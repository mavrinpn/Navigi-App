import 'package:flutter/material.dart';

import 'colors.dart';

class AppTypography {
  const AppTypography._();

  static const _colorBlack = AppColors.black;
  static const _lightGray = AppColors.lightGray;
  static const _white = Colors.white;
  static const _red = AppColors.red;
  static const _grey = AppColors.dark;
  static const _font = TextStyle(
    fontFamily: 'SF Pro Display',
    letterSpacing: -0.5,
  );

  static final font14black = _font.copyWith(
    color: _colorBlack,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
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
  static const font14white = TextStyle(
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
    color: _red,
    fontSize: 16,
    decoration: TextDecoration.underline,
  );
  static final font10red = _font.copyWith(
    color: _red,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
  );
  static final font14red = _font.copyWith(
    color: _red,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
  );
  static final font22red = _font.copyWith(
    color: _red,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.none,
  );
  static final font22black = _font.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w700,
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
  static final font16black = _font.copyWith(
    color: _colorBlack,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static final font24dark = _font.copyWith(
    color: AppColors.dark,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );
  static final font14light = _font.copyWith(
    color: AppColors.lightGray,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static final font12dark = _font.copyWith(color: AppColors.dark, fontSize: 12, fontWeight: FontWeight.w600);
  static final font12lightGray = _font.copyWith(color: AppColors.lightGray, fontSize: 12, fontWeight: FontWeight.w600);

  static final font18lightGray = _font.copyWith(color: AppColors.lightGray, fontSize: 18, fontWeight: FontWeight.w400);

  static final font16boldRed = _font.copyWith(color: AppColors.red, fontSize: 16, fontWeight: FontWeight.w700);
  static final font18black = _font.copyWith(color: _colorBlack, fontSize: 18, fontWeight: FontWeight.w500);
  static final font18gray = _font.copyWith(color: _grey, fontSize: 18, fontWeight: FontWeight.w600);

  static final font12gray = _font.copyWith(
    color: AppColors.lightGray,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static final font12black = _font.copyWith(
    color: AppColors.black,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static final font12normal = _font.copyWith(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static final font12w400 = _font.copyWith(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 0.12,
  );
}
