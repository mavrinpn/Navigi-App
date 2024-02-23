import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/subcategory/subcategory_cubit.dart';
import 'package:smart/feature/main/bloc/popularQueries/popular_queries_cubit.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/category/subcategory.dart';

import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';

class SearchSubcategoryScreen extends StatelessWidget {
  const SearchSubcategoryScreen({super.key});

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
          if (state is SubcategoriesGotState) {
            return ListView(
              children: bloc.subcategories
                  .map((e) => SubCategoryWidget(
                        subcategory: e,
                        onTap: () {
                          if (e.containsOther) {
                            bloc.getSubcategories(subcategoryId: e.id);
                          } else {
                            bloc.getSubcategoryFilters(e.id);
                            context
                                .read<SearchAnnouncementCubit>()
                                .setSubcategory(e.id);
                            context
                                .read<SearchAnnouncementCubit>()
                                .setSearchMode(SearchModeEnum.subcategory);
                            BlocProvider.of<PopularQueriesCubit>(context)
                                .loadPopularQueries();
                            BlocProvider.of<SearchAnnouncementCubit>(context)
                                .searchAnnounces('', true);
                            Navigator.pushNamed(context, AppRoutesNames.search);
                          }
                        },
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
