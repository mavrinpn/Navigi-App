import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/category/category_cubit.dart';
import 'package:smart/feature/main/bloc/popularQueries/popular_queries_cubit.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/feature/search/bloc/update_appbar_filter/update_appbar_filter_cubit.dart';
import 'package:smart/feature/search/ui/bottom_sheets/category_row_widget.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/main.dart';
import 'package:smart/managers/search_manager.dart';
import 'package:smart/models/models.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

class SubcategoryFilterBottomSheet extends StatefulWidget {
  const SubcategoryFilterBottomSheet({
    super.key,
    this.needOpenNewScreen = false,
  });

  final bool needOpenNewScreen;

  @override
  State<SubcategoryFilterBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<SubcategoryFilterBottomSheet> {
  Subcategory? newSubcategory;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context)!;

    final subcategoriesCubit = context.read<SearchSelectSubcategoryCubit>();
    final searchCubit = context.read<SearchAnnouncementCubit>();
    final updateAppBarFilterCubit = context.read<UpdateAppBarFilterCubit>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
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
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                localizations.choosingCategory,
                style: AppTypography.font20black,
              ),
            ),
            const SizedBox(height: 12),
          ],
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
                      category: category,
                      currentSubcategoryId: newSubcategory?.id ?? subcategoriesCubit.subcategoryId,
                      onSubcategoryChanged: (subcategory) {
                        newSubcategory = subcategory;
                        setState(() {});
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

                  searchCubit.setSubcategory(newSubcategory!.id);
                  searchCubit.setSearchMode(SearchModeEnum.subcategory);
                  subcategoriesCubit
                      .getSubcategoryFilters(newSubcategory!.id)
                      .then((value) => searchCubit.searchAnnounces(
                            searchText: '',
                            isNew: true,
                            showLoading: true,
                            parameters: value,
                          ));

                  RepositoryProvider.of<SearchManager>(context).setSearch(false);
                  BlocProvider.of<PopularQueriesCubit>(context).loadPopularQueries();

                  updateAppBarFilterCubit.needUpdateAppBarFilters(
                      title: newSubcategory!.localizedName(currentLocaleShortName.value));

                  setState(() {});
                }
              },
              text: localizations.apply,
              active: newSubcategory != null,
            )
          : null,
    );
  }
}
