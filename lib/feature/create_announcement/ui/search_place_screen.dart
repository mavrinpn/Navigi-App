import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/places_search/places_cubit.dart';
import 'package:smart/feature/create_announcement/ui/widgets/select_location_widget.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/constants.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../../../managers/creating_announcement_manager.dart';
import '../../../managers/places_manager.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_text_button.dart';

class SearchPlaceScreen extends StatefulWidget {
  const SearchPlaceScreen({super.key});

  @override
  State<SearchPlaceScreen> createState() => _SearchPlaceScreenState();
}

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {
  bool _active = false;
  String _place = '';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PlacesCubit>(context).searchCities('');
    final creatingManager = RepositoryProvider.of<CreatingAnnouncementManager>(context);
    if ([servicesCategoryId, realEstateCategoryId].contains(creatingManager.creatingData.categoryId)) {
      creatingManager.specialOptions.add(SpecialAnnouncementOptions.customPlace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final creatingManager = RepositoryProvider.of<CreatingAnnouncementManager>(context);
    final placeManager = RepositoryProvider.of<PlacesManager>(context);
    // final placesCubit = BlocProvider.of<PlacesCubit>(context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        backgroundColor: AppColors.appBarColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          localizations.place,
          style: AppTypography.font20black,
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        child: SelectLocationWidget(
          isProfile: false,
          onSetActive: (active) {
            setState(() {
              _active = active;
            });
          },
          onChangeCity: (name) {},
          onChangeDistrict: (cityDistrict) {
            _place = cityDistrict.name;
            placeManager.selectCity(cityDistrict.cityId);
          },
        ),
      ),
      floatingActionButton: CustomTextButton.orangeContinue(
        width: width - 30,
        text: localizations.continue_,
        callback: () {
          if (_active) {
            final place = placeManager.searchPlaceIdByName(_place)!;
            creatingManager.setPlace(place);
            //creatingManager.setTitle(creatingManager.buildTitle);

            Navigator.pushNamed(
              context,
              AppRoutesNames.announcementCreatingTitle,
            );
          }
        },
        active: _active,
      ),
    );
  }
}
