import 'package:flutter/material.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

class AuthErrorScreen extends StatefulWidget {
  const AuthErrorScreen({
    super.key,
    required this.message,
  });

  final String message;

  @override
  State<AuthErrorScreen> createState() => _FavoritesScreen();
}

class _FavoritesScreen extends State<AuthErrorScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.enter,
          style: AppTypography.font20black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.message),
              const SizedBox(height: 50),
              CustomTextButton.orangeContinue(
                callback: () {
                  Navigator.of(context).pop();
                },
                text: localizations.cancelation,
                active: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
