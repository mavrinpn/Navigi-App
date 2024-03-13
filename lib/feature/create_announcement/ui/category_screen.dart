import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/subcategory/subcategory_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/creating_announcement_manager.dart';
import 'package:smart/models/category.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/constants.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/category/category_widget.dart';

import '../bloc/category/category_cubit.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  void selectCategory(Category category) async {
    final creatingManager = context.read<CreatingAnnouncementManager>();

    BlocProvider.of<SubcategoryCubit>(context)
        .loadSubCategories(categoryId: category.id);
    creatingManager.clearSpecifications();

    if (category.id == realEstateCategoryId ||
        category.id == servicesCategoryId) {
      creatingManager.specialOptions
          .add(SpecialAnnouncementOptions.customPlace);
    }

    Navigator.pushNamed(
      context,
      AppRoutesNames.announcementCreatingSubcategory,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategorySuccessState) {
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
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: GridView.count(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 3,
                addAutomaticKeepAlives: true,
                childAspectRatio: 10 / 14,
                children: state.categories
                    .map((e) => CategoryWidget(
                          category: e,
                          onTap: () => selectCategory(e),
                        ))
                    .toList(),
              ),
            ),
          );
        } else if (state is CategoryFailState) {
          return const Center(
            child: Text('Loadding categories fail'),
          );
        } else {
          return Center(
            child: AppAnimations.bouncingLine,
          );
        }
      },
    );
  }
}
