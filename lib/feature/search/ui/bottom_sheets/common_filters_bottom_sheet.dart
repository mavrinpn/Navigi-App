import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart/feature/create_announcement/data/models/marks_filter.dart';
import 'package:smart/feature/create_announcement/ui/select_car_mark_screen.dart';
import 'package:smart/feature/create_announcement/ui/select_mark_screen.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/feature/search/bloc/update_appbar_filter/update_appbar_filter_cubit.dart';
import 'package:smart/feature/search/ui/widgets/filters/city_area_filter_widget.dart';
import 'package:smart/main.dart';
import 'package:smart/managers/search_manager.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/utils/constants.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/button/custom_text_button.dart';
import 'package:smart/widgets/parameters_selection/custom_dropdown_single_pick.dart';
import 'package:smart/widgets/parameters_selection/min_max_parameter.dart';
import 'package:smart/widgets/parameters_selection/multiple_chekbox.dart';
import 'package:smart/widgets/textField/price_widget.dart';

import '../../../../localization/app_localizations.dart';

class CommonFiltersBottomSheet extends StatefulWidget {
  const CommonFiltersBottomSheet({
    super.key,
    this.needOpenNewScreen = false,
  });

  final bool needOpenNewScreen;

  @override
  State<CommonFiltersBottomSheet> createState() =>
      _CommonFiltersBottomSheetState();
}

class _CommonFiltersBottomSheetState extends State<CommonFiltersBottomSheet> {
  bool radiusOptionShown = false;
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
    final localizations = AppLocalizations.of(context)!;

    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);
    final selectCategoryCubit =
        BlocProvider.of<SearchSelectSubcategoryCubit>(context);
    final updateAppBarFilterCubit = context.read<UpdateAppBarFilterCubit>();

    choosedMarksFilter = searchCubit.marksFilter;
    choosedCarFilter = selectCategoryCubit.autoFilter;

    final TextEditingController minPriceController =
        TextEditingController(text: '${searchCubit.minPrice ?? ''}');
    final TextEditingController maxPriceController =
        TextEditingController(text: '${searchCubit.maxPrice ?? ''}');

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.9,
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations.filters,
                          style: AppTypography.font20black,
                        ),
                        InkWell(
                          onTap: () {
                            updateAppBarFilterCubit.needUpdateAppBarFilters();
                            searchCubit.clearFilters();
                            selectCategoryCubit.clearFilters();
                            for (var param in selectCategoryCubit.parameters) {
                              if (param is SelectParameter) {
                                param.selectedVariants = [];
                              } else if (param is MinMaxParameter) {
                                param.min = null;
                                param.max = null;
                              }
                            }

                            setState(() {});
                          },
                          child: Text(
                            localizations.resetEverything,
                            style: AppTypography.font12gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 90),
              child: SingleChildScrollView(
                clipBehavior: Clip.hardEdge,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PriceWidget(
                        minPriceController: minPriceController,
                        maxPriceController: maxPriceController,
                      ),
                      CustomDropDownSingleCheckBox(
                        icon: 'Assets/icons/tirage.svg',
                        parameter: searchCubit.sortTypesParameter,
                        onChange: (parametrOption) {
                          searchCubit.sortTypesParameter
                              .setVariant(parametrOption);
                          searchCubit.sortType = parametrOption.key;
                          setState(() {});
                        },
                        currentKey: searchCubit.sortBy,
                      ),
                      if (selectCategoryCubit.subcategoryId == carSubcategoryId)
                        ..._buildCarMarkWidget(context),
                      if (selectCategoryCubit.subcategoryFilters != null &&
                          selectCategoryCubit.subcategoryFilters!.hasMark &&
                          selectCategoryCubit.subcategoryId != carSubcategoryId)
                        ..._buildSelectMarkWidget(context),
                      ..._buildLocationWidget(context),
                      if (searchCubit.marksFilter?.modelParameters != null)
                        ...buildModelFilters(),
                      if (searchCubit.searchMode ==
                          SearchModeEnum.subcategory) ...[
                        BlocBuilder<SearchSelectSubcategoryCubit,
                            SearchSelectSubcategoryState>(
                          builder: (context, state) {
                            if (state is FiltersGotState) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: buildFiltersSelection(
                                      selectCategoryCubit.parameters),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                      const SizedBox(height: 16),
                      CustomTextButton.orangeContinue(
                        callback: () {
                          RepositoryProvider.of<SearchManager>(context)
                              .setSearch(false);
                          searchCubit.minPrice =
                              double.tryParse(minPriceController.text);
                          searchCubit.maxPrice =
                              double.tryParse(maxPriceController.text);
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
          ],
        ),
      ),
    );
  }

  List<Widget> buildFiltersSelection(List<Parameter> parameters) {
    final children = <Widget>[];
    for (var i in parameters) {
      if (i is SelectParameter) {
        children.add(MultipleCheckboxPicker(
          parameter: i,
          wrapDirection: Axis.horizontal,
        ));
      } else if (i is MinMaxParameter) {
        children.add(MinMaxParameterWidget(parameter: i));
      }
    }
    return children;
  }

  List<Widget> buildModelFilters() {
    final searchCubit = RepositoryProvider.of<SearchAnnouncementCubit>(context);
    final parameters = searchCubit.marksFilter!.modelParameters!;

    final children = <Widget>[];
    for (var i in parameters) {
      if (i is SelectParameter) {
        children.add(MultipleCheckboxPicker(
          parameter: i,
          wrapDirection: Axis.horizontal,
        ));
      } else if (i is MinMaxParameter) {
        children.add(MinMaxParameterWidget(parameter: i));
      }
    }
    return children;
  }

  List<Widget> _buildCarMarkWidget(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final selectCategoryCubit =
        BlocProvider.of<SearchSelectSubcategoryCubit>(context);
    final updateAppBarFilterCubit = context.read<UpdateAppBarFilterCubit>();
    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);

    return [
      Material(
        color: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SelectCarMarkScreen(
                  needSelectModel: true,
                  subcategory: selectCategoryCubit.subcategoryId!,
                ),
              ),
            ).then((filter) {
              if (filter != null) {
                setState(() {
                  choosedCarFilter = filter;
                });
                searchCubit.setMarksFilter(MarksFilter(
                  markId: filter.markId,
                  markTitle: filter.markTitle,
                  modelTitle: filter.modelTitle,
                ));
                selectCategoryCubit.setAutoFilter(filter);

                searchCubit.setFilters(
                  parameters: selectCategoryCubit.parameters,
                  cityId: selectedCityId,
                  areaId: selectedAreaId,
                  cityTitle: selectedCityTitle,
                  areaTitle: selectedAreaTitle,
                );
                setState(() {});
              }
              updateAppBarFilterCubit.needUpdateAppBarFilters();
            });
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 8, 4, 8),
            child: Row(
              children: [
                Text(
                  localizations.choosingCarBrand,
                  style: AppTypography.font16black.copyWith(fontSize: 18),
                ),
                const Spacer(),
                choosedCarFilter == null
                    ? const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 16,
                        color: AppColors.lightGray,
                      )
                    : const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: AppColors.lightGray,
                      )
              ],
            ),
          ),
        ),
      ),
      if (choosedCarFilter != null) ...[
        const SizedBox(height: 16),
        Text(
          '${choosedCarFilter.markTitle} ${choosedCarFilter.modelTitle}',
          style: AppTypography.font18lightGray,
        ),
      ],
      const SizedBox(height: 10),
    ];
  }

  List<Widget> _buildSelectMarkWidget(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final selectCategoryCubit =
        BlocProvider.of<SearchSelectSubcategoryCubit>(context);
    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);

    return [
      Material(
        color: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: InkWell(
          onTap: () async {
            final needSelectModel =
                selectCategoryCubit.subcategoryFilters!.hasModel;
            final List<MarksFilter>? filter = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SelectMarkScreen(
                  needSelectModel: needSelectModel,
                  subcategory: selectCategoryCubit.subcategoryId!,
                ),
              ),
            );

            if (filter != null && filter.isNotEmpty) {
              setState(() {
                choosedMarksFilter = filter.first;
              });
              searchCubit.setMarksFilter(filter.first);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                Text(
                  localizations.choosingMark,
                  style: AppTypography.font16black.copyWith(fontSize: 18),
                ),
                const Spacer(),
                choosedMarksFilter == null
                    ? const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 16,
                        color: AppColors.lightGray,
                      )
                    : const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: AppColors.lightGray,
                      )
              ],
            ),
          ),
        ),
      ),
      if (choosedMarksFilter != null) ...[
        const SizedBox(height: 16),
        Text(
          '${choosedMarksFilter.markTitle} ${choosedMarksFilter.modelTitle}',
          style: AppTypography.font18lightGray,
        ),
      ],
      const SizedBox(height: 10),
    ];
  }

  List<Widget> _buildLocationWidget(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);

    return [
      Material(
        color: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: InkWell(
          onTap: showHideRadiusOption,
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
                const SizedBox(width: 10),
                const Spacer(),
                !radiusOptionShown
                    ? const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 16,
                        color: AppColors.lightGray,
                      )
                    : const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: AppColors.lightGray,
                      ),
              ],
            ),
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
