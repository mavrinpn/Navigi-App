import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart/feature/create_announcement/bloc/places_search/places_cubit.dart';
import 'package:smart/feature/create_announcement/ui/specify_place.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/creating_announcement_manager.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/city.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/button/custom_text_button.dart';
import 'package:smart/widgets/category/products.dart';
import 'package:smart/widgets/textField/outline_text_field.dart';

class SelectLocationWidget extends StatefulWidget {
  const SelectLocationWidget({
    super.key,
    required this.onSetActive,
    required this.onChangePlace,
    this.cityDistrict,
    this.longitude,
    this.latitude,
  });

  final CityDistrict? cityDistrict;
  final double? longitude;
  final double? latitude;
  final Function(bool active) onSetActive;
  final Function(String place) onChangePlace;

  @override
  State<SelectLocationWidget> createState() => _SelectLocationWidgetState();
}

class _SelectLocationWidgetState extends State<SelectLocationWidget> {
  final placeController = TextEditingController();
  final cityController = TextEditingController();

  CityDistrict? _cityDistrict;

  bool initial = false;
  bool selectingCity = true;
  bool isCoordinatesSelected = false;

  @override
  void initState() {
    super.initState();

    if (widget.cityDistrict != null) {
      _cityDistrict = widget.cityDistrict;
      placeController.text = _cityDistrict!.name;
    }
    BlocProvider.of<PlacesCubit>(context).initialLoad();
  }

  void setActive(bool value) {
    final creatingManager =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);
    if (creatingManager.specialOptions
        .contains(SpecialAnnouncementOptions.customPlace)) {
      if (isCoordinatesSelected) {
        widget.onSetActive(value);
      }
    } else {
      widget.onSetActive(value);
    }
  }

  void selectCity(City city) async {
    final placesCubit = BlocProvider.of<PlacesCubit>(context);

    await placesCubit.setCity(city).then((value) {
      BlocProvider.of<PlacesCubit>(context).searchPlaces('');
      cityController.text = city.name;
      selectingCity = false;

      placeController.text = '';
      widget.onChangePlace('');

      setActive(false);
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
    widget.onChangePlace(selectedDistrict.name);

    _cityDistrict = selectedDistrict;

    setActive(true);
    setState(() {
      selectingCity = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final creatingManager =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);
    // final placeManager = RepositoryProvider.of<PlacesManager>(context);
    final placesCubit = BlocProvider.of<PlacesCubit>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 13),
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
              if (state is PlacesSuccessState || state is PlacesLoadingState) {
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
            widget.onChangePlace(value);
            // setActive(placeManager.searchCityIdByName(value) != null);
            setState(() {});
          },
        ),
        const SizedBox(height: 16),
        if (!selectingCity) ...[
          BlocBuilder<PlacesCubit, PlacesState>(
            builder: (context, state) {
              if (state is PlacesSuccessState || state is PlacesLoadingState) {
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
            active: _cityDistrict != null,
            callback: () async {
              if (_cityDistrict != null) {
                final LatLng? latLng = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SpecifyPlaceScreen(
                      placeData: _cityDistrict!,
                      longitude: widget.longitude ?? _cityDistrict!.longitude,
                      latitude: widget.latitude ?? _cityDistrict!.latitude,
                    ),
                  ),
                );
                if (latLng != null) {
                  setState(() {
                    isCoordinatesSelected = true;
                    setActive(true);
                  });
                  creatingManager.customPosition = latLng;
                }
              }
            },
            text: "Indiquer l'emplacement sur la carte",
          )
        ]
      ],
    );
  }
}
