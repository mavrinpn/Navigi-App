// ignore_for_file: prefer_const_declarations

import 'package:flutter/material.dart';
import 'colors.dart';

abstract class AppAnimations {
  // static final circleFadingAnimation = SpinKitFadingCircle(
  //   itemBuilder: (_, ind) {
  //     return const Padding(
  //       padding: EdgeInsets.all(1.8),
  //       child: DecoratedBox(decoration: BoxDecoration(color: AppColors.red, shape: BoxShape.circle)),
  //     );
  //   },
  //   size: 86,
  // );

  // static final bouncingLine = LoadingBouncingLine.circle(
  //   backgroundColor: AppColors.red,
  //   size: 40,
  // );

  static final circleFadingAnimation = const Center(
    child: CircularProgressIndicator(
      color: AppColors.red,
    ),
  );

  static final bouncingLine = const Center(
    child: CircularProgressIndicator(
      color: AppColors.red,
    ),
  );
}
