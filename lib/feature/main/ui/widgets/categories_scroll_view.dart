import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/category/category_cubit.dart';
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
          final items = getCategories(state.categories, context);
          return SizedBox(
            width: double.infinity,
            height: 140,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) => items[index],
              separatorBuilder: (context, index) => const SizedBox(width: 10),
            ),
          );
        } else if (state is CategoryFailState) {
          return const Center(
            child: Text('Category loading fail'),
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
        .map((e) => CategoryWidget(
              category: e,
              onTap: () {
                context
                    .read<SearchSelectSubcategoryCubit>()
                    .getSubcategories(categoryId: e.id);
                Navigator.pushNamed(
                    context, AppRoutesNames.searchSelectSubcategory);
              },
              width: 108,
              height: 140,
            ))
        .toList();
  }
}
