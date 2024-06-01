import 'package:flutter/material.dart';
import 'package:smart/utils/animations.dart';

bool _overlayShowed = false;

mixin LoadingMixin {
  void showLoadingOverlay(BuildContext context) {
    if (!_overlayShowed) {
      _overlayShowed = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const LoadingOverlay();
        },
      );
    }
  }

  void hideLoadingOverlay(BuildContext context) {
    if (_overlayShowed) {
      _overlayShowed = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppAnimations.bouncingLine,
    );
  }
}
