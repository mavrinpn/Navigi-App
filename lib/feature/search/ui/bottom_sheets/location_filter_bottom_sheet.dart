import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/feature/search/bloc/update_appbar_filter/update_appbar_filter_cubit.dart';
import 'package:smart/feature/search/ui/widgets/filters/city_area_filter_widget.dart';
import 'package:smart/main.dart';
import 'package:smart/managers/search_manager.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

import '../../../../localization/app_localizations.dart';

class LocationFilterBottomSheet extends StatefulWidget {
  const LocationFilterBottomSheet({
    super.key,
    this.needOpenNewScreen = false,
  });

  final bool needOpenNewScreen;

  @override
  State<LocationFilterBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<LocationFilterBottomSheet> {
  bool radiusOptionShown = true;
  double sliderValue = 0;

  String? selectedCityId;
  String? selectedAreaId;
  String? selectedCityTitle;
  String? selectedAreaTitle;
  double kilometerRatio = 100;

  void requestLocation() async {
    await Geolocator.requestPermission();
    await Geolocator.openLocationSettings();
  }

  void showHideRadiusOption() async {
    if (!radiusOptionShown) {
      final locationEnabled = await Geolocator.isLocationServiceEnabled();

      if (locationEnabled) {
        setState(() {
          radiusOptionShown = !radiusOptionShown;
        });
      } else {
        requestLocation();
      }
    } else {
      setState(() {
        radiusOptionShown = false;
      });
    }
  }

  void changeRadius(double value) {}

  dynamic choosedMarksFilter;
  dynamic choosedCarFilter;

  String locale() => MyApp.getLocale(context) ?? 'fr';

  @override
  Widget build(BuildContext context) {
    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);
    final selectCategoryCubit =
        BlocProvider.of<SearchSelectSubcategoryCubit>(context);
    final updateAppBarFilterCubit = context.read<UpdateAppBarFilterCubit>();

    return Container(
      // height: MediaQuery.sizeOf(context).height * 0.9,
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 120,
                    height: 4,
                    decoration: ShapeDecoration(
                        color: const Color(0xFFDDE1E7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1))),
                  ),
                ),
                const SizedBox(height: 12),
                ..._buildLocationWidget(context),
                const SizedBox(height: 16),
                CustomTextButton.orangeContinue(
                  callback: () {
                    RepositoryProvider.of<SearchManager>(context)
                        .setSearch(false);

                    searchCubit.setFilters(
                      parameters: selectCategoryCubit.parameters,
                      cityId: selectedCityId,
                      areaId: selectedAreaId,
                      cityTitle: selectedCityTitle,
                      areaTitle: selectedAreaTitle,
                    );
                    Navigator.pop(context);

                    if (widget.needOpenNewScreen) {
                      Navigator.pushNamed(
                        context,
                        AppRoutesNames.search,
                        arguments: {
                          'showSearchHelper': false,
                        },
                      );
                    }

                    updateAppBarFilterCubit.needUpdateAppBarFilters();

                    setState(() {});
                  },
                  text: locale() == 'fr' ? 'Appliquer' : 'تطبيق',
                  active: true,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLocationWidget(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);

    return [
      Material(
        color: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              SvgPicture.asset(
                'Assets/icons/point2.svg',
                width: 26,
                height: 26,
              ),
              const SizedBox(width: 10),
              Text(
                localizations.location,
                style: AppTypography.font16black,
              ),
            ],
          ),
        ),
      ),
      if (radiusOptionShown) ...[
        CityAreaFilterWidget(
          cityTitle: searchCubit.cityTitle ?? '',
          areaTitle: searchCubit.areaTitle ?? '',
          onSelecetCity: (id, title) {
            selectedCityId = id;
            selectedCityTitle = title;
          },
          onSelecetArea: (id, title) {
            selectedAreaId = id;
            selectedAreaTitle = title;
          },
        ),
        // Slider(
        //   thumbColor: AppColors.red,
        //   activeColor: AppColors.red,
        //   value: sliderValue,
        //   onChanged: (b) {
        //     setState(() {
        //       sliderValue = b;
        //       context.read<SearchAnnouncementCubit>().radius =
        //           b * kilometerRatio;
        //     });
        //   },
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 25.0),
        //   child:
        //       Text('${(sliderValue * kilometerRatio).toStringAsFixed(2)} km'),
        // ),
      ],
      const SizedBox(height: 10),
    ];
  }
}
