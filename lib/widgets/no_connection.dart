import 'package:flutter/material.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/fonts.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xffED5434),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                localizations.noConnection,
                textAlign: TextAlign.center,
                style: AppTypography.font14white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
