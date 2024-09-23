import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:loading_animations/loading_animations.dart';

import 'colors.dart';

abstract class AppAnimations {
  static final circleFadingAnimation = SpinKitFadingCircle(
    itemBuilder: (_, ind) {
      return const Padding(
        padding: EdgeInsets.all(1.8),
        child: DecoratedBox(decoration: BoxDecoration(color: AppColors.red, shape: BoxShape.circle)),
      );
    },
    size: 86,
  );

  // static final bouncingLine = LoadingBouncingLine.circle(
  //   backgroundColor: AppColors.red,
  //   size: 40,
  // );

  // ignore: prefer_const_declarations
  static final bouncingLine = const Center(
    child: CircularProgressIndicator(
      color: AppColors.red,
    ),
  );
}
