import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/main/bloc/announcements/announcements_cubit.dart';
import 'package:smart/feature/main/ui/widgets/filled_text_button.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/bloc/update_city/update_city_cubit.dart';
import 'package:smart/feature/search/ui/bottom_sheets/filter_bottom_sheet_dialog.dart';
import 'package:smart/feature/search/ui/bottom_sheets/filter_keys.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/colors.dart';

class CityButton extends StatefulWidget {
  const CityButton({super.key});

  @override
  State<CityButton> createState() => _CityButtonState();
}

class _CityButtonState extends State<CityButton> {
  @override
  void initState() {
    _setCity();
    super.initState();
  }

  void _setCity() {
    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);
    BlocProvider.of<AnnouncementsCubit>(context).loadAnnounces(
      true,
      cityId: searchCubit.cityId,
      areaId: searchCubit.areaId,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateCityCubit, UpdateCityState>(
      listener: (context, state) {
        _setCity();
      },
      builder: (context, state) {
        return FilledTextButton(
          onPressed: () {
            showFilterBottomSheet(
              context: context,
              parameterKey: FilterKeys.location,
              needOpenNewScreen: false,
            );
          },
          title: _cityName(context),
          icon: SvgPicture.asset(
            'Assets/icons/arrow_down.svg',
            colorFilter: const ColorFilter.mode(AppColors.red, BlendMode.srcIn),
          ),
        );
      },
    );
  }

  String _cityName(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);
    String name = localizations.location;

    if (searchCubit.cityTitle != null) {
      name = searchCubit.cityTitle!;
    }

    if (searchCubit.distrinctTitle != null) {
      name += ' / ${searchCubit.distrinctTitle}';
    }

    return name;
  }
}
