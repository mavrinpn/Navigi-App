import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/category/category_cubit.dart';
import 'package:smart/feature/main/bloc/popularQueries/popular_queries_cubit.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/feature/search/bloc/update_appbar_filter/update_appbar_filter_cubit.dart';
import 'package:smart/feature/search/ui/bottom_sheets/category_row_widget.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/search_manager.dart';
import 'package:smart/models/models.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

class SubcategoriesWidget extends StatefulWidget {
  const SubcategoriesWidget({
    super.key,
    this.needOpenNewScreen = false,
    required this.isBottomSheet,
    this.searchText,
  });

  final bool needOpenNewScreen;
  final bool isBottomSheet;
  final String? searchText;

  @override
  State<SubcategoriesWidget> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<SubcategoriesWidget> {
  Subcategory? newSubcategory;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context)!;

    final subcategoriesCubit = context.read<SearchSelectSubcategoryCubit>();
    final searchCubit = context.read<SearchAnnouncementCubit>();
    final updateAppBarFilterCubit = context.read<UpdateAppBarFilterCubit>();

    return Scaffold(
      appBar: widget.isBottomSheet
          ? AppBar(
              backgroundColor: AppColors.appBarColor,
              automaticallyImplyLeading: false,
              toolbarHeight: 76,
              flexibleSpace: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 120,
                      height: 4,
                      decoration: ShapeDecoration(
                          color: const Color(0xFFDDE1E7),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations.choosingCategory,
                          style: AppTypography.font18gray,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            searchCubit.setSubcategory(null);
                            searchCubit.setSearchMode(SearchModeEnum.simple);
                            subcategoriesCubit.getSubcategoryFilters('').then((value) => searchCubit.searchAnnounces(
                                  searchText: '',
                                  isNew: true,
                                  showLoading: true,
                                  parameters: [],
                                ));

                            RepositoryProvider.of<SearchManager>(context).setSearch(false);
                            BlocProvider.of<PopularQueriesCubit>(context).loadPopularQueries();

                            updateAppBarFilterCubit.needUpdateAppBarFilters(title: '');
                          },
                          child: Text(
                            localizations.reset,
                            style: AppTypography.font14lightGray.copyWith(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : AppBar(
              title: Text(
                localizations.choosingCategory,
                style: AppTypography.font18gray,
              ),
            ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategorySuccessState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...state.categories.map((category) {
                    return CategoryRowWidget(
                      isExpanded: !widget.isBottomSheet,
                      category: category,
                      currentSubcategoryId: newSubcategory?.id ?? subcategoriesCubit.subcategoryId,
                      onSubcategoryTapped: (subcategory) {
                        if (widget.isBottomSheet) {
                          newSubcategory = subcategory;
                          setState(() {});
                        } else {
                          onSubcategoryTapped(subcategory);
                        }
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 100),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: newSubcategory != null
          ? CustomTextButton.orangeContinue(
              width: width - 30,
              callback: () {
                if (newSubcategory != null) {
                  Navigator.pop(context);

                  searchCubit.setSubcategory(newSubcategory!);
                  searchCubit.setSearchMode(SearchModeEnum.subcategory);
                  subcategoriesCubit
                      .getSubcategoryFilters(newSubcategory!.id)
                      .then((value) => searchCubit.searchAnnounces(
                            searchText: widget.searchText,
                            isNew: true,
                            showLoading: true,
                            parameters: value,
                          ));

                  RepositoryProvider.of<SearchManager>(context).setSearch(false);
                  BlocProvider.of<PopularQueriesCubit>(context).loadPopularQueries();

                  updateAppBarFilterCubit.needUpdateAppBarFilters(title: newSubcategory!.localizedName());

                  setState(() {});
                }
              },
              text: localizations.apply,
              active: newSubcategory != null,
            )
          : null,
    );
  }

  void onSubcategoryTapped(Subcategory subcategory) async {
    final subcategoriesCubit = context.read<SearchSelectSubcategoryCubit>();

    if (subcategory.containsOther) {
      subcategoriesCubit.getSubcategories(subcategoryId: subcategory.id);
    } else {
      final searchCubit = context.read<SearchAnnouncementCubit>();

      searchCubit.setSubcategory(subcategory);
      searchCubit.setSearchMode(SearchModeEnum.subcategory);
      subcategoriesCubit.getSubcategoryFilters(subcategory.id).then((value) async {
        // final SharedPreferences prefs = await SharedPreferences.getInstance();
        // final cityDistrictString = prefs.getString(cityDistrictKey);
        // if (cityDistrictString != null) {
        //   final cityDistrict = CityDistrict.fromMap(jsonDecode(cityDistrictString));
        //   searchCubit.setCity(
        //     cityId: cityDistrict.cityId,
        //     areaId: cityDistrict.id,
        //     cityTitle: cityDistrict.cityTitle,
        //     areaTitle: cityDistrict.name,
        //   );
        // }

        searchCubit.searchAnnounces(
          searchText: '',
          isNew: true,
          showLoading: true,
          parameters: value,
        );
      });

      RepositoryProvider.of<SearchManager>(context).setSearch(false);
      BlocProvider.of<PopularQueriesCubit>(context).loadPopularQueries();

      Navigator.pushNamed(
        context,
        AppRoutesNames.search,
        arguments: {
          'showBackButton': false,
          'showSearchHelper': false,
          'title': subcategory.localizedName(),
        },
      );
    }
  }
}
