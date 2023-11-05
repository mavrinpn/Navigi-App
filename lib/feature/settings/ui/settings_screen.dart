import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/main.dart';

import '../../../models/custom_locate.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/singleCheckBox/CustomSinglCheckBox.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
        shortName: AppLocalizations.of(context)!.localeName,
        name: AppLocalizations.of(context)!.localeName == 'ar'
            ? CustomLocate.ar().name
            : CustomLocate.fr().name);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.empty,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              focusColor: AppColors.empty,
              hoverColor: AppColors.empty,
              highlightColor: AppColors.empty,
              splashColor: AppColors.empty,
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 35,
                height: 48,
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.black,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Paramètres de lapplication',
                    style: AppTypography.font20black,
                  ),
                ],
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
              onChange: (CustomLocate? a) {
                MyApp.setLocate(context, Locale(a!.shortName));
                customLocate = a;
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
