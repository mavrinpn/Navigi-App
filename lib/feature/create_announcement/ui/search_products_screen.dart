import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../../../managers/creating_announcement_manager.dart';
import '../../../managers/item_manager.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../../widgets/category/products.dart';
import '../../../widgets/textField/outline_text_field.dart';
import '../bloc/item_search/item_search_cubit.dart';

class SearchProductsScreen extends StatefulWidget {
  const SearchProductsScreen({super.key});

  @override
  State<SearchProductsScreen> createState() => _SearchProductsScreenState();
}

class _SearchProductsScreenState extends State<SearchProductsScreen> {
  final productsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final creatingManager =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);
    final itemManager = RepositoryProvider.of<ItemManager>(context);

    final cubit = BlocProvider.of<ItemSearchCubit>(context);

    productsController.text = cubit.getSearchText();
    productsController.selection = TextSelection.fromPosition(
        TextPosition(offset: productsController.text.length));
    final width = MediaQuery.of(context).size.width;

    bool buttonActive = cubit.getSearchText().isNotEmpty;

    void setIsTouch(bool isT) {
      buttonActive = isT;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        backgroundColor: AppColors.empty,
        elevation: 0,
        title: Text(
          localizations.indicateTheName,
          style: AppTypography.font20black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            OutLineTextField(
              controller: productsController,
              height: 55,
              hintText: '',
              width: double.infinity,
              onChange: (value) {
                BlocProvider.of<ItemSearchCubit>(context).searchItems(value);
                setIsTouch(value.isNotEmpty);
                setState(() {});
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 26, 0, 13),
              child: Text(
                localizations.popularRequests,
                style: AppTypography.font16black.copyWith(fontSize: 14),
              ),
            ),
            BlocBuilder<ItemSearchCubit, ItemSearchState>(
              builder: (context, state) {
                if (state is SearchSuccessState ||
                    state is SearchLoadingState) {
                  return Wrap(
                    children: cubit
                        .getItems()
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(3),
                              child: ProductWidget(
                                onTap: () {
                                  cubit.setItemName(e.name);
                                  creatingManager.setItem(e);
                                  setState(() {});
                                },
                                name: e.name,
                              ),
                            ))
                        .toList(),
                  );
                } else if (state is SearchEmptyState) {
                  return Center(
                    child: Text(localizations.notFound),
                  );
                } else if (state is SearchFailState) {
                  return Center(
                    child: Text(localizations.errorReviewOrEnterOther),
                  );
                } else {
                  return Center(
                    child: AppAnimations.bouncingLine,
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: CustomTextButton.orangeContinue(
        width: width - 30,
        text: localizations.continue_,
        callback: () {
          if (buttonActive) {
            final item = itemManager.hasItemInSearchedItems();

            creatingManager.setItem(item,
                name: productsController.text, id: item?.id);
            Navigator.pushNamed(
                context, AppRoutesNames.announcementCreatingPhoto);
          }
        },
        active: buttonActive,
      ),
    );
  }
}
