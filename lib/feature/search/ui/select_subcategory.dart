import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/subcategory/subcategory_cubit.dart';
import 'package:smart/feature/main/bloc/popularQueries/popular_queries_cubit.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/main.dart';
import 'package:smart/managers/search_manager.dart';
import 'package:smart/models/subcategory.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/category/subcategory.dart';

import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';

class SearchSubcategoryScreen extends StatefulWidget {
  const SearchSubcategoryScreen({super.key});

  @override
  State<SearchSubcategoryScreen> createState() =>
      _SearchSubcategoryScreenState();
}

class _SearchSubcategoryScreenState extends State<SearchSubcategoryScreen> {
  bool subcategoriesGot = false;

  void onSubcategoryTapped(Subcategory e) {
    final subcategoriesCubit = context.read<SearchSelectSubcategoryCubit>();

    if (e.containsOther) {
      subcategoriesGot = false;
      subcategoriesCubit.getSubcategories(subcategoryId: e.id);
    } else {
      final searchCubit = context.read<SearchAnnouncementCubit>();

      searchCubit.setSubcategory(e.id);
      searchCubit.setSearchMode(SearchModeEnum.subcategory);
      subcategoriesCubit.getSubcategoryFilters(e.id).then(
          (value) => searchCubit.searchAnnounces('', true, parameters: value));

      RepositoryProvider.of<SearchManager>(context).setSearch(false);
      BlocProvider.of<PopularQueriesCubit>(context).loadPopularQueries();

      final String currentLocale = MyApp.getLocale(context) ?? 'fr';

      Navigator.pushNamed(
        context,
        AppRoutesNames.search,
        arguments: {
          'showBackButton': false,
          'title': currentLocale == 'fr' ? e.nameFr : e.nameAr
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final bloc = BlocProvider.of<SearchSelectSubcategoryCubit>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        backgroundColor: AppColors.empty,
        elevation: 0,
        title: Text(
          localizations.addAnAd,
          style: AppTypography.font20black,
        ),
      ),
      body: BlocBuilder<SearchSelectSubcategoryCubit,
          SearchSelectSubcategoryState>(
        builder: (context, state) {
          if (state is SubcategoriesGotState || subcategoriesGot) {
            if (!subcategoriesGot) subcategoriesGot = true;

            return ListView(
              children: bloc.subcategories
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
