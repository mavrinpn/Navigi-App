import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/feature/create_announcement/bloc/category/category_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/main.dart';
import 'package:smart/models/custom_locate.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/parameters_selection/single_pick_list.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  CustomLocale? customLocate;

  List<CustomLocale> listLocates = [
    CustomLocale.fr(),
    CustomLocale.ar(),
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    customLocate = CustomLocale(
        shortName: localizations.localeName,
        name: localizations.localeName == 'ar' ? CustomLocale.ar().name : CustomLocale.fr().name);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset('Assets/icons/language.svg'),
              const SizedBox(width: 16),
              Text(
                localizations.language,
                style: AppTypography.font18black,
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomSingleCheckBoxes(
            parameters: listLocates,
            onChange: (CustomLocale? a) async {
              MyApp.setLocate(context, Locale(a!.shortName));
              customLocate = a;

              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString(langKey, a.shortName);
              currentLocaleShortName.value = a.shortName;

              context.read<CategoryCubit>().loadCategories();

              setState(() {});
            },
            currentVariable: customLocate!,
          ),
        ],
      ),
    );
  }
}
