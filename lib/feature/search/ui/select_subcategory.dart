import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/subcategory/subcategory_cubit.dart';
import 'package:smart/feature/main/bloc/popularQueries/popular_queries_cubit.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/feature/search/ui/loading_mixin.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/search_manager.dart';
import 'package:smart/models/subcategory.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/category/subcategory.dart';

import '../../../utils/fonts.dart';

class SearchSubcategoryScreen extends StatefulWidget {
  const SearchSubcategoryScreen({super.key});

  @override
  State<SearchSubcategoryScreen> createState() => _SearchSubcategoryScreenState();
}

class _SearchSubcategoryScreenState extends State<SearchSubcategoryScreen> with LoadingMixin {
  bool subcategoriesGot = false;

  void onSubcategoryTapped(Subcategory subcategory) async {
    final subcategoriesCubit = context.read<SearchSelectSubcategoryCubit>();

    if (subcategory.containsOther) {
      subcategoriesGot = false;
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
          'isSubcategory': true,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final aearchSelectSubcategoryCubit = BlocProvider.of<SearchSelectSubcategoryCubit>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        backgroundColor: AppColors.appBarColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          localizations.selectSubcategory,
          style: AppTypography.font20black,
        ),
      ),
      body: BlocBuilder<SearchSelectSubcategoryCubit, SearchSelectSubcategoryState>(
        builder: (context, state) {
          if (state is SubcategoriesGotState || subcategoriesGot) {
            if (!subcategoriesGot) subcategoriesGot = true;

            return ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: aearchSelectSubcategoryCubit.subcategories
                  .map((e) => SubCategoryWidget(
                        subcategory: e,
                        onTap: () => onSubcategoryTapped(e),
                      ))
                  .toList(),
            );
          } else if (state is SubcategoryFailState) {
            return Center(
              child: Text(localizations.errorReviewOrEnterOther),
            );
          } else {
            return Center(child: AppAnimations.bouncingLine);
          }
        },
      ),
    );
  }
}
