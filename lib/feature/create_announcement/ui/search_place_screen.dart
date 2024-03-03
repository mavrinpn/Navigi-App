import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart/feature/create_announcement/bloc/places_search/places_cubit.dart';
import 'package:smart/feature/create_announcement/ui/specify_place.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/city.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../../../managers/creating_announcement_manager.dart';
import '../../../managers/places_manager.dart';
import '../../../utils/animations.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../../widgets/category/products.dart';
import '../../../widgets/textField/outline_text_field.dart';

class SearchPlaceScreen extends StatefulWidget {
  const SearchPlaceScreen({super.key});

  @override
  State<SearchPlaceScreen> createState() => _SearchPlaceScreenState();
}

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {
  final placeController = TextEditingController();
  final cityController = TextEditingController();

  bool active = false;
  bool initial = false;
  bool selectingCity = true;

  @override
  void initState() {
    BlocProvider.of<PlacesCubit>(context).searchCities('');
    super.initState();
  }

  void setActive(bool value) => active = value;

  void selectCity(City city) async {
    final placesCubit = BlocProvider.of<PlacesCubit>(context);

    await placesCubit.setCity(city).then((value) {
      BlocProvider.of<PlacesCubit>(context).searchPlaces('');
      cityController.text = city.name;
      selectingCity = false;

      setState(() {});
    });
  }

  void selectPlace(CityDistrict selectedDistrict) async {
    final creatingManager =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);
    final placesCubit = BlocProvider.of<PlacesCubit>(context);

    placesCubit.setPlaceName(selectedDistrict.name);
    creatingManager.setPlace(selectedDistrict);

    placeController.text = selectedDistrict.name;

    district = selectedDistrict;
    setActive(true);
    setState(() {
      // initial = true;
      selectingCity = true;
    });
  }

  CityDistrict? district;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final creatingManager =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);
    final placeManager = RepositoryProvider.of<PlacesManager>(context);
    final placesCubit = BlocProvider.of<PlacesCubit>(context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        backgroundColor: AppColors.empty,
        elevation: 0,
        title: Text(
          localizations.place,
          style: AppTypography.font20black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 26, 0, 13),
              child: Text(
                localizations.city,
                style: AppTypography.font16black.copyWith(fontSize: 14),
              ),
            ),
            OutlineTextField(
              controller: cityController,
              height: 55,
              hintText: '',
              width: double.infinity,
              onChange: (value) {
                setState(() {
                  selectingCity = true;
                  initial = false;
                  setActive(false);
                });
                BlocProvider.of<PlacesCubit>(context).searchCities(value);
              },
            ),
            const SizedBox(height: 16),
            if (selectingCity && !initial) ...[
              BlocBuilder<PlacesCubit, PlacesState>(
                builder: (context, state) {
                  if (state is PlacesSuccessState ||
                      state is PlacesLoadingState) {
                    return Wrap(
                      children: placesCubit
                          .getCities()
                          .map((e) => Padding(
                                padding: const EdgeInsets.all(3),
                                child: ProductWidget(
                                  onTap: () => selectCity(e),
                                  name: e.name,
                                ),
                              ))
                          .toList(),
                    );
                  } else if (state is PlacesEmptyState) {
                    return Center(
                      child: Text(localizations.notFound),
                    );
                  } else if (state is PlacesFailState) {
                    return Center(
                      child: Text(localizations.errorReviewOrEnterOther),
                    );
                  } else {
                    return Center(
                      child: AppAnimations.bouncingLine,
                    );
                  }
                },
              ),
            ],
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 13),
              child: Text(
                localizations.area,
                style: AppTypography.font16black.copyWith(fontSize: 14),
              ),
            ),
            OutlineTextField(
              controller: placeController,
              height: 55,
              hintText: '',
              width: double.infinity,
              readonly: selectingCity,
              onChange: (value) {
                BlocProvider.of<PlacesCubit>(context).searchPlaces(value);
                // setActive(placeManager.searchCityIdByName(value) != null);
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            if (!selectingCity) ...[
              BlocBuilder<PlacesCubit, PlacesState>(
                builder: (context, state) {
                  if (state is PlacesSuccessState ||
                      state is PlacesLoadingState) {
                    return Wrap(
                      children: placesCubit
                          .getPlaces()
                          .map((e) => Padding(
                                padding: const EdgeInsets.all(3),
                                child: ProductWidget(
                                  onTap: () => selectPlace(e),
                                  name: e.name,
                                ),
                              ))
                          .toList(),
                    );
                  } else if (state is PlacesEmptyState) {
                    return Center(
                      child: Text(localizations.notFound),
                    );
                  } else if (state is PlacesFailState) {
                    return Center(
                      child: Text(localizations.errorReviewOrEnterOther),
                    );
                  } else {
                    return Center(
                      child: AppAnimations.bouncingLine,
                    );
                  }
                },
              ),
            ],
            const SizedBox(height: 16),
            if (creatingManager.specialOptions
                .contains(SpecialAnnouncementOptions.customPlace)) ...[
              CustomTextButton.orangeContinue(
                activeColor: AppColors.dark,
                active: active,
                callback: () async {
                  if (active) {
                    final LatLng latLng = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                SpecifyPlaceScreen(placeData: district!)));

                    creatingManager.customPosition = latLng;
                  }
                },
                text: "Indiquer l'emplacement sur la carte",
              )
            ]
          ],
        ),
      ),
      floatingActionButton: CustomTextButton.orangeContinue(
        width: width - 30,
        text: localizations.continue_,
        callback: () {
          if (active) {
            final place =
                placeManager.searchPlaceIdByName(placeController.text)!;
            creatingManager.setPlace(place);
            creatingManager.setTitle(creatingManager.buildTitle);

            Navigator.pushNamed(
                context, AppRoutesNames.announcementCreatingDescription);
          }
        },
        active: active,
      ),
    );
  }
}
