import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/creating_blocs.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/main.dart';
import 'package:smart/utils/routes/route_names.dart';

class CategoriesChips extends StatelessWidget {
  const CategoriesChips({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategorySuccessState) {
            final categories = state.categories;

            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 6,
                    children: [
                      ...categories.map(
                        (category) {
                          return FilterChip(
                            label: Text(
                              category.getLocalizedName(MyApp.getLocale(context) ?? 'fr'),
                              style: const TextStyle(color: Colors.black),
                            ),
                            onSelected: (value) {
                              context.read<SearchSelectSubcategoryCubit>().getSubcategories(
                                    categoryId: category.id,
                                  );
                              Navigator.pushNamed(
                                context,
                                AppRoutesNames.searchSelectSubcategory,
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
