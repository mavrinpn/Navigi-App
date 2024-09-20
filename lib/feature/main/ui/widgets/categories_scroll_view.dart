import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/feature/create_announcement/bloc/category/category_cubit.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/feature/search/ui/widgets/category_shimmer.dart';
import 'package:smart/models/category.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/category/category_widget.dart';

class CategoriesScrollView extends StatelessWidget {
  const CategoriesScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    final itemWidth = (MediaQuery.of(context).size.width - 15 * 2 - 10 * 2) / 3;
    final itemHeight = itemWidth / 10 * 14;

    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategorySuccessState) {
          final items = getCategories(
            state.categories,
            context,
            itemWidth,
          );

          return SizedBox(
            height: itemHeight,
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
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
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: const Center(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 50,
                  children: [
                    CategoryShimmer(),
                    CategoryShimmer(),
                    CategoryShimmer(),
                    CategoryShimmer(),
                    CategoryShimmer(),
                    CategoryShimmer(),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  List<Widget> getCategories(
    List<Category> categories,
    BuildContext context,
    double itemWidth,
  ) {
    return categories
        .map((e) => SizedBox(
              width: itemWidth,
              child: CategoryWidget(
                category: e,
                onTap: () {
                  context.read<SearchSelectSubcategoryCubit>().getSubcategories(categoryId: e.id);
                  Navigator.pushNamed(context, AppRoutesNames.searchSelectSubcategory);
                },
                // width: 108,
                // height: 140,
              ),
            ))
        .toList();
  }
}
