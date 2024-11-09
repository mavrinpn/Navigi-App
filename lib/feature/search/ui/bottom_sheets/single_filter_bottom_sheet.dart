import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/feature/search/bloc/update_appbar_filter/update_appbar_filter_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/main.dart';
import 'package:smart/managers/search_manager.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/button/custom_text_button.dart';
import 'package:smart/widgets/parameters_selection/min_max_parameter.dart';
import 'package:smart/widgets/parameters_selection/multiple_chekbox.dart';
import 'package:smart/widgets/parameters_selection/select_parameter_widget.dart';

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
    final localizations = AppLocalizations.of(context)!;
    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);
    final selectCategoryCubit = BlocProvider.of<SearchSelectSubcategoryCubit>(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ),
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                clipBehavior: Clip.none,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Container(
                          width: 120,
                          height: 4,
                          decoration: ShapeDecoration(
                              color: const Color(0xFFDDE1E7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (searchCubit.searchMode == SearchModeEnum.subcategory) ...[
                                BlocBuilder<SearchSelectSubcategoryCubit, SearchSelectSubcategoryState>(
                                  builder: (context, state) {
                                    if (state is FiltersGotState) {
                                      return Stack(
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ...buildFiltersSelection(selectCategoryCubit.parameters),
                                            ],
                                          ),
                                        ],
                                      );
                                    }

                                    return Container();
                                  },
                                ),
                              ],
                              const SizedBox(height: 70),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: Directionality.of(context) == TextDirection.ltr ? 12 : null,
                left: Directionality.of(context) == TextDirection.rtl ? 12 : null,
                top: 32,
                child: TextButton(
                  onPressed: () {
                    for (var parameter in selectCategoryCubit.parameters) {
                      if (parameter.key == widget.parameterKey) {
                        if (parameter is SelectParameter) {
                          parameter.selectedVariants = [];
                        } else if (parameter is SingleSelectParameter) {
                          parameter.setVariant(emptyParameterOption);
                        } else if (parameter is MultiSelectParameter) {
                          parameter.selectedVariants = [];
                        } else if (parameter is MinMaxParameter) {
                          parameter.min = null;
                          parameter.max = null;
                        }
                      }
                    }
                    _onSubmit();
                  },
                  child: Text(localizations.reset),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 20,
                right: 20,
                child: CustomTextButton.orangeContinue(
                  callback: () {
                    _onSubmit();
                  },
                  text: localizations.apply,
                  active: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);
    final updateAppBarFilterCubit = context.read<UpdateAppBarFilterCubit>();
    final selectCategoryCubit = BlocProvider.of<SearchSelectSubcategoryCubit>(context);

    RepositoryProvider.of<SearchManager>(context).setSearch(false);

    searchCubit.setFilters(
      parameters: selectCategoryCubit.parameters,
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
  }

  List<Widget> buildFiltersSelection(List<Parameter> parameters) {
    final children = <Widget>[];
    for (var i in parameters) {
      if (i.key == widget.parameterKey) {
        if (i is SelectParameter) {
          children.add(MultipleCheckboxPicker(
            parameter: i,
            wrapDirection: Axis.vertical,
            onChange: () => setState(() {}),
          ));
        } else if (i is SingleSelectParameter) {
          children.add(SelectParameterWidget(
            isClickable: false,
            parameter: i,
            onChange: () => setState(() {}),
          ));
        } else if (i is MultiSelectParameter) {
          children.add(MultipleCheckboxPicker(
            parameter: i,
            wrapDirection: Axis.vertical,
            onChange: () => setState(() {}),
          ));
        } else if (i is MinMaxParameter) {
          children.add(MinMaxParameterWidget(parameter: i));
        }
      }
    }
    return children;
  }
}
