import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/main.dart';
import 'package:smart/widgets/button/back_button.dart';

import '../../../models/custom_locate.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/parameters_selection/single_pick_list.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

List<CustomLocate> listLocates = [
  CustomLocate.fr(),
  CustomLocate.ar(),
];

class _SettingsScreenState extends State<SettingsScreen> {
  CustomLocate? customLocate;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    customLocate = CustomLocate(
        shortName: localizations.localeName,
        name: localizations.localeName == 'ar' ? CustomLocate.ar().name : CustomLocate.fr().name);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.empty,
        elevation: 0,
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('Assets/icons/language.svg'),
            CustomSingleCheckBoxes(
              parameters: listLocates,
              onChange: (CustomLocate? a) async {
                MyApp.setLocate(context, Locale(a!.shortName));
                customLocate = a;

                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('lang', a.shortName);
                currentLocaleShortName.value = a.shortName;

                setState(() {});
              },
              currentVariable: customLocate!,
            ),
          ],
        ),
      ),
    );
  }
}
