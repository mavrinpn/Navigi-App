import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/main.dart';
import 'package:smart/managers/search_manager.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/button/custom_text_button.dart';
import 'package:smart/widgets/parameters_selection/min_max_parameter.dart';
import 'package:smart/widgets/parameters_selection/multiple_chekbox.dart';

class SingleFilterBottomSheet extends StatefulWidget {
  const SingleFilterBottomSheet({
    super.key,
    this.needOpenNewScreen = false,
    required this.parameterKey,
  });

  final bool needOpenNewScreen;
  final String parameterKey;

  @override
  State<SingleFilterBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<SingleFilterBottomSheet> {
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
                    children: [
                      Text(
                        localizations.filters,
                        style: AppTypography.font20black,
                      ),
                    ],
                  ),
                ),
                if (searchCubit.searchMode == SearchModeEnum.subcategory) ...[
                  BlocBuilder<SearchSelectSubcategoryCubit,
                      SearchSelectSubcategoryState>(
                    builder: (context, state) {
                      if (state is FiltersGotState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: buildFiltersSelection(
                              selectCategoryCubit.parameters),
                        );
                      }

                      return Container();
                    },
                  ),
                ],
                const SizedBox(height: 16),
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
                  active: true,
                )
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
      if (i.key == widget.parameterKey) {
        if (i is SelectParameter) {
          children.add(MultipleCheckboxPicker(parameter: i));
        } else if (i is MinMaxParameter) {
          children.add(MinMaxParameterWidget(parameter: i));
        }
      }
    }
    return children;
  }
}