import 'package:flutter/material.dart';
import 'package:smart/feature/settings/widgets/language_selector.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/button/back_button.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appBarColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 6,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomBackButton(),
            Expanded(
              child: Text(
                localizations.placeApplicationSettings,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: AppTypography.font20black,
              ),
            )
          ],
        ),
      ),
      body: const LanguageSelector(),
    );
  }
}
