import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/places_search/places_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/city.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/category/products.dart';
import 'package:smart/widgets/textField/outline_text_field.dart';

class CityAreaFilterWidget extends StatefulWidget {
  const CityAreaFilterWidget({
    super.key,
    required this.onSelecetCity,
    required this.onSelecetArea,
  });

  final Function(String? id) onSelecetCity;
  final Function(String? id) onSelecetArea;

  @override
  State<CityAreaFilterWidget> createState() => _CityAreaFilterWidgetState();
}

class _CityAreaFilterWidgetState extends State<CityAreaFilterWidget> {
  final placeController = TextEditingController();
  final cityController = TextEditingController();

  bool active = false;
  bool initial = false;
  bool selectingCity = true;

  CityDistrict? district;

  void selectCity(City city) async {
    final placesCubit = BlocProvider.of<PlacesCubit>(context);

    await placesCubit.setCity(city).then((value) {
      BlocProvider.of<PlacesCubit>(context).searchPlaces('');
      cityController.text = city.name;
      selectingCity = false;
      widget.onSelecetCity(city.id);
      resetPlace();

      setState(() {});
    });
  }

  void resetPlace() {
    final placesCubit = BlocProvider.of<PlacesCubit>(context);
    placesCubit.setPlaceName('');

    placeController.text = '';
    widget.onSelecetArea(null);

    district = null;
    setState(() {});
  }

  void selectPlace(CityDistrict selectedDistrict) async {
    final placesCubit = BlocProvider.of<PlacesCubit>(context);
    placesCubit.setPlaceName(selectedDistrict.name);

    placeController.text = selectedDistrict.name;
    widget.onSelecetArea(selectedDistrict.id);

    district = selectedDistrict;
    setState(() {
      selectingCity = true;
    });
  }

  @override
  void initState() {
    BlocProvider.of<PlacesCubit>(context).initialLoad();
    BlocProvider.of<PlacesCubit>(context).searchCities('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final placesCubit = BlocProvider.of<PlacesCubit>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
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
              });
              BlocProvider.of<PlacesCubit>(context).searchCities(value);
            },
          ),
          const SizedBox(height: 10),
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
            padding: const EdgeInsets.symmetric(vertical: 12),
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
        ],
      ),
    );
  }
}
