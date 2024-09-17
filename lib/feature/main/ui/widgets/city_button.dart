import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/main/bloc/announcements/announcements_cubit.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/bloc/update_appbar_filter/update_appbar_filter_cubit.dart';
import 'package:smart/feature/search/ui/bottom_sheets/filter_bottom_sheet_dialog.dart';
import 'package:smart/feature/search/ui/bottom_sheets/filter_keys.dart';
import 'package:smart/localization/app_localizations.dart';

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
    return BlocConsumer<UpdateAppBarFilterCubit, UpdateAppBarFilterState>(
      listener: (context, state) {
        _setCity();
      },
      builder: (context, state) {
        return TextButton(
          onPressed: () {
            showFilterBottomSheet(
              context: context,
              parameterKey: FilterKeys.location,
            );
          },
          child: Text(_cityName(context)),
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

    //TODO cityName
    if (searchCubit.distrinctTitle != null) {
      name += ' / ${searchCubit.distrinctTitle}';
    }

    return name;
  }
}
