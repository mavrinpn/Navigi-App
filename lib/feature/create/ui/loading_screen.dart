import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 262,
          height: 256,
          child: Column(
            children: [
              SpinKitFadingCircle(
                itemBuilder: (_, ind) {return const Padding(
                  padding: EdgeInsets.all(0.2),
                  child: DecoratedBox(decoration: BoxDecoration(color: AppColors.red, shape: BoxShape.circle)),
                );},
                size: 86,
              ),
              const SizedBox(
                height: 54,
              ),
              const SizedBox(
                width: 262,
                child: Text(
                  'La modération de l\'annonce est en cours',
                  textAlign: TextAlign.center,
                  style: AppTypography.font24dark,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const SizedBox(
                width: 262,
                child: Text(
                  'Ne bloquez pas l\'application pendant le traitement de votre annonce',
                  textAlign: TextAlign.center,
                  style: AppTypography.font14light
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
