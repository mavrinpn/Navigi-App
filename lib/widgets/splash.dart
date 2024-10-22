import 'package:flutter/material.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

class Splash extends StatelessWidget {
  const Splash({
    super.key,
    required this.showConnectedButton,
    this.resetLoginHasConnection,
  });

  final bool showConnectedButton;
  final Function? resetLoginHasConnection;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xffED5434),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: Colors.transparent,
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 300,
            child: Image.asset(
              'Assets/splash.png',
              width: MediaQuery.of(context).size.width * 0.6,
            ),
          ),
          if (showConnectedButton)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text(
                    localizations.noConnection,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextButton.orangeContinue(
                    callback: () {
                      resetLoginHasConnection?.call();
                    },
                    text: '',
                    activeColor: Colors.white,
                    disableColor: Colors.white,
                    child: Text(
                      localizations.repeat,
                      style: const TextStyle(
                        color: AppColors.red,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            const Column(
              children: [
                SizedBox(height: 40),
                CircularProgressIndicator(
                  color: Colors.transparent,
                ),
              ],
            ),
        ],
      )),
    );
  }
}
