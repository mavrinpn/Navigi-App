import 'package:flutter/material.dart.';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/category/category_cubit.dart';
import 'package:smart/feature/main/bloc/popularQueries/popular_queries_cubit.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/models/category.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/category/category.dart';

class CategoriesScrollView extends StatelessWidget {
  const CategoriesScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategorySuccessState) {
          return SizedBox(
            width: double.infinity,
            height: 160,
            child: ListView(
              physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast),
              scrollDirection: Axis.horizontal,
              children: getCategories(state.categories, context),
            ),
          );
        } else if (state is CategoryFailState) {
          return const Center(
            child: Text('Проблемс'),
          );
        } else {
          return Center(
            child: AppAnimations.bouncingLine,
          );
        }
      },
    );
  }

  List<Widget> getCategories(List<Category> categories, BuildContext context) {
    return categories
        .map((e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: CategoryWidget(
                category: e,
                onTap: () {
                  // if (e.id == '651194bfe89e3b67023f') {
                  //   final bloc =
                  //       BlocProvider.of<SearchSelectSubcategoryCubit>(context);
                  //
                  //   const String autoId = '65d22164b9589fde26d9';
                  //   context
                  //       .read<SearchSelectSubcategoryCubit>().autoFilter = null;
                  //   context
                  //       .read<SearchSelectSubcategoryCubit>()
                  //       .setAutoSubcategory();
                  //   context
                  //       .read<SearchSelectSubcategoryCubit>()
                  //       .getSubcategoryFilters(autoId);
                  //   context
                  //       .read<SearchAnnouncementCubit>()
                  //       .setSubcategory(autoId);
                  //   context
                  //       .read<SearchAnnouncementCubit>()
                  //       .setSearchMode(SearchModeEnum.subcategory);
                  //   BlocProvider.of<PopularQueriesCubit>(context)
                  //       .loadPopularQueries();
                  //   BlocProvider.of<SearchAnnouncementCubit>(context)
                  //       .searchAnnounces('', true);
                  //   Navigator.pushNamed(context, AppRoutesNames.search);
                  // } else {
                    context
                        .read<SearchSelectSubcategoryCubit>()
                        .getSubcategories(categoryId: e.id);
                    Navigator.pushNamed(
                        context, AppRoutesNames.searchSelectSubcategory);
                  // }
                },
                width: 108,
                height: 160,
              ),
            ))
        .toList();
  }
}
