import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/item_search/item_search_cubit.dart';
import 'package:smart/feature/create_announcement/data/models/marks_filter.dart';
import 'package:smart/feature/create_announcement/ui/select_mark_screen.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/creating_announcement_manager.dart';
import 'package:smart/models/item/subcategory_filters.dart';
import 'package:smart/models/subcategory.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/category/subcategory.dart';

import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../bloc/subcategory/subcategory_cubit.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  Future<MarksFilter?> getMarksFilters(
      SubcategoryFilters parameters, String subcategoryId) async {
    final MarksFilter? marksFilter;

    if (parameters.hasMark) {
      marksFilter = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => SelectMarkScreen(
                    subcategory: subcategoryId,
                    needSelectModel: parameters.hasModel,
                  )));
    } else {
      marksFilter = null;
    }
    return marksFilter;
  }

  void setParametersToManagerAndPushNext(
      SubcategoryFilters parameters, MarksFilter? marksFilter) {
    if (marksFilter == null && parameters.hasMark) return;

    final repository = context.read<CreatingAnnouncementManager>();
    repository.subcategoryFilters = parameters;
    repository.marksFilter = marksFilter;

    // print(
    // 'subcategory parameters select, length: ${repository.subcategoryFilters!.parameters.length}');

    Navigator.pushNamed(context, AppRoutesNames.announcementCreatingItem);
  }

  void getSubcategoryParameters(Subcategory subcategory) async {
    final parameters = await context
        .read<ItemSearchCubit>()
        .getSubcategoryFilters(subcategory.id);
    final marksFilters = await getMarksFilters(parameters, subcategory.id);
    setParametersToManagerAndPushNext(parameters, marksFilters);
  }

  void selectSubcategory(Subcategory subcategory) {
    if (!subcategory.containsOther) {
      context.read<ItemSearchCubit>().setSubcategory(subcategory.id);
      getSubcategoryParameters(subcategory);
    } else {
      context
          .read<SubcategoryCubit>()
          .loadSubCategories(subcategoryId: subcategory.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
      body: BlocBuilder<SubcategoryCubit, SubcategoryState>(
        builder: (context, state) {
          if (state is SubcategorySuccessState) {
            return ListView(
              children: state.subcategories
                  .map((e) => SubCategoryWidget(
                      subcategory: e, onTap: () => selectSubcategory(e)))
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
