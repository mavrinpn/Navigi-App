import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart/feature/create_announcement/data/models/marks_filter.dart';
import 'package:smart/feature/create_announcement/ui/select_auto_model_screen.dart';
import 'package:smart/feature/create_announcement/ui/select_mark_screen.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/main.dart';
import 'package:smart/managers/search_manager.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/button/custom_text_button.dart';
import 'package:smart/widgets/parameters_selection/custom_dropdown_single_pick.dart';
import 'package:smart/widgets/parameters_selection/min_max_parameter.dart';
import 'package:smart/widgets/parameters_selection/multiple_chekbox.dart';
import 'package:smart/widgets/textField/price_widget.dart';

import '../../../../localization/app_localizations.dart';

class FiltersBottomSheet extends StatefulWidget {
  const FiltersBottomSheet({
    super.key,
    this.needOpenNewScreen = false,
  });

  final bool needOpenNewScreen;

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  bool radiusOptionShown = false;
  double sliderValue = 0;

  double kilometerRatio = 100;

  void requestLocation() async {
    await Geolocator.requestPermission();
    await Geolocator.openLocationSettings();
  }

  void showHideRadiusOption() async {
    if (!radiusOptionShown) {
      final locationEnabled = await Geolocator.isLocationServiceEnabled();
      // print(locationEnabled);
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

  String locale() => MyApp.getLocale(context) ?? 'fr';

  @override
  Widget build(BuildContext context) {
    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);
    final localizations = AppLocalizations.of(context)!;

    final selectCategoryCubit =
        BlocProvider.of<SearchSelectSubcategoryCubit>(context);

    final TextEditingController minPriceController =
        TextEditingController(text: searchCubit.minPrice.toString());
    final TextEditingController maxPriceController =
        TextEditingController(text: searchCubit.maxPrice.toString());

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.8,
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 16,
                ),
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
                          searchCubit.clearFilters();
                          setState(() {});
                        },
                        child: Text(
                          localizations.resetEverything,
                          style: AppTypography.font12black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                PriceWidget(
                  minPriseController: minPriceController,
                  maxPriseController: maxPriceController,
                ),
                CustomDropDownSingleCheckBox(
                  parameter: searchCubit.sortTypesParameter,
                  onChange: (parametrOption) {
                    searchCubit.sortTypesParameter.setVariant(parametrOption);
                    searchCubit.sortType = parametrOption.key;
                    setState(() {});
                  },
                  // currentVariable: SortTypes.frTranslates[searchCubit.sortBy]!,
                  currentKey: searchCubit.sortBy,
                ),
                if (selectCategoryCubit.needAddAutoSelectButton &&
                    selectCategoryCubit.autoFilter == null) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SelectAutoModelScreen(
                                      needSelectModel: true,
                                    ))).then((value) {
                          selectCategoryCubit.setAutoFilter(value);
                          setState(() {});
                          // print(
                          // 'rebuild with ${selectCategoryCubit.autoFilter != null}');
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            'Choisir une marque ',
                            style: AppTypography.font16black
                                .copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
                if (selectCategoryCubit.subcategoryFilters != null &&
                    selectCategoryCubit.subcategoryFilters!.hasMark) ...[
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () async {
                      final MarksFilter filter = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SelectMarkScreen(
                                    needSelectModel: true,
                                    subcategory:
                                        selectCategoryCubit.subcategoryId!,
                                  )));

                      searchCubit.setMarksFilter(filter);
                    },
                    child: Row(
                      children: [
                        Text(
                          locale() == 'fr'
                              ? 'Choisir une marque'
                              : 'اختر علامة تجارية',
                          style:
                              AppTypography.font16black.copyWith(fontSize: 18),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                          color: AppColors.lightGray,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'Assets/icons/point.svg',
                          width: 26,
                          height: 26,
                          colorFilter: const ColorFilter.mode(
                            AppColors.red,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          locale() == 'fr' ? 'Rayon' : 'دائرة نصف قطرها',
                          style: AppTypography.font16black,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: showHideRadiusOption,
                          child: !radiusOptionShown
                              ? const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 16,
                                  color: AppColors.lightGray,
                                )
                              : const Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: AppColors.lightGray,
                                ),
                        ),
                      ],
                    ),
                    if (radiusOptionShown) ...[
                      Slider(
                          thumbColor: AppColors.red,
                          activeColor: AppColors.red,
                          value: sliderValue,
                          onChanged: (b) {
                            setState(() {
                              sliderValue = b;
                              context.read<SearchAnnouncementCubit>().radius =
                                  b * kilometerRatio;
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                            '${(sliderValue * kilometerRatio).toStringAsFixed(2)} km'),
                      )
                    ]
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                if (searchCubit.marksFilter?.modelParameters != null)
                  ...buildModelFilters(),
                if (searchCubit.searchMode == SearchModeEnum.subcategory) ...[
                  BlocBuilder<SearchSelectSubcategoryCubit,
                      SearchSelectSubcategoryState>(
                    builder: (context, state) {
                      if (state is FiltersGotState) {
                        return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: buildFiltersSelection(
                                selectCategoryCubit.parameters));
                      }

                      return Container();
                    },
                  ),
                ],
                const SizedBox(
                  height: 16,
                ),
                CustomTextButton.orangeContinue(
                    callback: () {
                      RepositoryProvider.of<SearchManager>(context)
                          .setSearch(false);
                      searchCubit.minPrice =
                          double.parse(minPriceController.text);
                      searchCubit.maxPrice =
                          double.parse(maxPriceController.text);
                      searchCubit.setFilters(
                          parameters: selectCategoryCubit.parameters);
                      Navigator.pop(context);

                      if (widget.needOpenNewScreen) {
                        Navigator.pushNamed(context, AppRoutesNames.search);
                      }

                      setState(() {});
                    },
                    text: locale() == 'fr' ? 'Appliquer' : 'تطبيق',
                    active: true)
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildFiltersSelection(List<Parameter> parameters) {
    final children = <Widget>[];
    for (var i in parameters) {
      if (i is SelectParameter) {
        children.add(MultipleCheckboxPicker(parameter: i));
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
        children.add(MultipleCheckboxPicker(parameter: i));
      } else if (i is MinMaxParameter) {
        children.add(MinMaxParameterWidget(parameter: i));
      }
    }
    return children;
  }
}
