import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_kit_interface/map_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:smart/widgets/textField/custom_text_field.dart';
import 'package:smart/widgets/textField/outline_text_field.dart';

const cityDistrictKey = 'cityDistrictKey';

class SelectLocationWidget extends StatefulWidget {
  const SelectLocationWidget({
    super.key,
    required this.onSetActive,
    required this.onChangeCity,
    required this.onChangeDistrict,
    required this.isProfile,
    this.cityDistrict,
    this.longitude,
    this.latitude,
  });

  final bool isProfile;
  final CityDistrict? cityDistrict;
  final double? longitude;
  final double? latitude;
  final Function(bool active) onSetActive;
  final Function(String name) onChangeCity;
  final Function(CityDistrict city) onChangeDistrict;

  @override
  State<SelectLocationWidget> createState() => _SelectLocationWidgetState();
}

class _SelectLocationWidgetState extends State<SelectLocationWidget> {
  final distrinctController = TextEditingController();
  final cityController = TextEditingController();

  final placeFocusNode = FocusNode();
  final cityFocusNode = FocusNode();

  CityDistrict? _cityDistrict;

  bool initial = false;
  bool selectingCity = true;
  bool isCoordinatesSelected = false;

  @override
  void initState() {
    super.initState();

    if (widget.cityDistrict != null) {
      _cityDistrict = widget.cityDistrict;
      distrinctController.text = _cityDistrict!.name;
    }
    BlocProvider.of<PlacesCubit>(context).initialLoad();

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPersistDate());
  }

  _loadPersistDate() async {
    if (widget.cityDistrict != null) {
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cityDistrictString = prefs.getString(cityDistrictKey);

    if (cityDistrictString != null) {
      final cityDistrict = CityDistrict.fromMap(jsonDecode(cityDistrictString));
      _cityDistrict = cityDistrict;
      distrinctController.text = cityDistrict.name;
      cityController.text = cityDistrict.cityTitle;
      widget.onChangeCity(cityDistrict.cityTitle);
      widget.onChangeDistrict(cityDistrict);
      setActive(true);
      setState(() {});
    }
  }

  void setActive(bool value) {
    if (isCoordinatesSelected) {
      widget.onSetActive(value);
    }
    // final creatingManager = RepositoryProvider.of<CreatingAnnouncementManager>(context);
    // if (creatingManager.specialOptions.contains(SpecialAnnouncementOptions.customPlace)) {
    //   if (isCoordinatesSelected) {
    //     widget.onSetActive(value);
    //   }
    // } else {
    //   widget.onSetActive(value);
    // }
  }

  void selectCity(City city) async {
    final placesCubit = BlocProvider.of<PlacesCubit>(context);

    await placesCubit.setCity(city).then((value) {
      BlocProvider.of<PlacesCubit>(context).searchPlaces('');
      cityController.text = city.name;
      widget.onChangeCity(city.name);
      selectingCity = false;

      distrinctController.text = '';
      widget.onChangeDistrict(CityDistrict.none());

      setActive(false);
      setState(() {});
      // cityFocusNode.requestFocus();
      placeFocusNode.requestFocus();
    });
  }

  void selectPlace(CityDistrict selectedDistrict) async {
    final creatingManager = RepositoryProvider.of<CreatingAnnouncementManager>(context);
    final placesCubit = BlocProvider.of<PlacesCubit>(context);

    placesCubit.setPlaceName(selectedDistrict.name);
    creatingManager.setPlace(selectedDistrict);

    distrinctController.text = selectedDistrict.name;
    widget.onChangeDistrict(selectedDistrict);

    _cityDistrict = selectedDistrict;

    setActive(true);
    // setState(() {
    //   selectingCity = true;
    // });
    placeFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final creatingManager = RepositoryProvider.of<CreatingAnnouncementManager>(context);
    // final placeManager = RepositoryProvider.of<PlacesManager>(context);
    final placesCubit = BlocProvider.of<PlacesCubit>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isProfile)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 13),
            child: Text(
              localizations.city,
              style: AppTypography.font16black.copyWith(fontSize: 14),
            ),
          ),
        if (widget.isProfile)
          CustomTextFormField(
            controller: cityController,
            focusNode: cityFocusNode,
            keyboardType: TextInputType.text,
            hintText: localizations.city,
            prefIcon: 'Assets/icons/point2.svg',
            onChanged: (value) {
              setState(() {
                selectingCity = true;
                initial = false;
                setActive(false);
              });
              BlocProvider.of<PlacesCubit>(context).searchCities(value ?? '');
            },
          )
        else
          OutlineTextField(
            controller: cityController,
            focusNode: cityFocusNode,
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
        if (selectingCity && !initial) ...[
          BlocBuilder<PlacesCubit, PlacesState>(
            builder: (context, state) {
              if (state is PlacesSuccessState || state is PlacesLoadingState) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                  child: Wrap(
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
                  ),
                );
              } else if (state is PlacesEmptyState) {
                return const SizedBox.shrink();
                // return Center(
                //   child: Text(localizations.notFound),
                // );
              } else if (state is PlacesFailState) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                  child: Center(
                    child: Text(localizations.errorReviewOrEnterOther),
                  ),
                );
              } else {
                return Center(
                  child: AppAnimations.bouncingLine,
                );
              }
            },
          ),
        ],
        if (!widget.isProfile)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
            child: Text(
              localizations.area,
              style: AppTypography.font16black.copyWith(fontSize: 14),
            ),
          ),
        if (widget.isProfile)
          CustomTextFormField(
            controller: distrinctController,
            focusNode: placeFocusNode,
            hintText: localizations.area,
            readOnly: selectingCity,
            keyboardType: TextInputType.text,
            prefIcon: 'Assets/icons/point2.svg',
            onChanged: (value) {
              BlocProvider.of<PlacesCubit>(context).searchPlaces(value ?? '');
              // widget.onChangeDistrict(value ?? '');
              setActive(false);
              // setActive(placeManager.searchCityIdByName(value) != null);
              setState(() {});
            },
          )
        else
          OutlineTextField(
            controller: distrinctController,
            focusNode: placeFocusNode,
            height: 55,
            hintText: '',
            width: double.infinity,
            readonly: selectingCity,
            onChange: (value) {
              BlocProvider.of<PlacesCubit>(context).searchPlaces(value);
              widget.onChangeDistrict(CityDistrict.none());
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
        // if (creatingManager.specialOptions.contains(SpecialAnnouncementOptions.customPlace))
        CustomTextButton.orangeContinue(
          active: _cityDistrict != null,
          callback: () async {
            if (_cityDistrict != null) {
              final CommonLatLng? latLng = await Navigator.push(
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
        ),
      ],
    );
  }
}
