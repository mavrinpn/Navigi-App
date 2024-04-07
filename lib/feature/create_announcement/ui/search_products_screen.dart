import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/keywords/keywords_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/category/products.dart';

import '../../../managers/creating_announcement_manager.dart';
import '../../../managers/item_manager.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_text_button.dart';
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

    final creatingManager = RepositoryProvider.of<CreatingAnnouncementManager>(context);
    final itemManager = RepositoryProvider.of<ItemManager>(context);

    // final cubit = BlocProvider.of<ItemSearchCubit>(context);
    // productsController.text = cubit.getSearchText();
    productsController.selection = TextSelection.fromPosition(TextPosition(offset: productsController.text.length));
    final width = MediaQuery.of(context).size.width;

    // bool buttonActive = cubit.getSearchText().isNotEmpty;
    bool buttonActive = productsController.text != '';

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
            OutlineTextField(
              controller: productsController,
              height: 55,
              hintText: '',
              width: double.infinity,
              onChange: (value) {
                //String lastWord = value.trimRight().split(' ').lastOrNull ?? '';

                final creatingManager = RepositoryProvider.of<CreatingAnnouncementManager>(context);
                BlocProvider.of<KeyWordsCubit>(context).getKeywordsBy(
                  subcategoryId: creatingManager.creatingData.subcategoryId ?? '',
                  query: value,
                );

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
            Expanded(
              child: BlocBuilder<KeyWordsCubit, KeyWordsState>(
                builder: (context, state) {
                  if (state is KeyWordssSuccessState) {
                    return SingleChildScrollView(
                      child: Wrap(
                        children: [
                          ...state.keywords.take(8).map((e) {
                            String name = '';
                            if (e.nameFr.toLowerCase().contains(state.currentQuery.toLowerCase())) {
                              name = e.nameFr;
                            }
                            if (e.nameAr.toLowerCase().contains(state.currentQuery.toLowerCase())) {
                              name = e.nameAr;
                            }
                            return Padding(
                              padding: const EdgeInsets.all(3),
                              child: ProductWidget(
                                onTap: () {
                                  // creatingManager.setItem(e);
                                  setState(() {});
                                  _setTitle(name);
                                },
                                name: name,
                              ),
                            );
                          }).toList(),
                          // ...state.keyWordsFr
                          //     .take(8)
                          //     .map((e) => Padding(
                          //           padding: const EdgeInsets.all(3),
                          //           child: ProductWidget(
                          //             onTap: () {
                          //               _setTitle(e.nameFr);
                          //             },
                          //             name: e.nameFr,
                          //           ),
                          //         ))
                          //     .toList(),
                          // ...state.keyWordsAr
                          //     .take(8)
                          //     .map((e) => Padding(
                          //           padding: const EdgeInsets.all(3),
                          //           child: ProductWidget(
                          //             onTap: () {
                          //               _setTitle(e.nameAr);
                          //               // cubit.setItemName(e.name);
                          //               // creatingManager.setItem(e);
                          //               // setState(() {});
                          //             },
                          //             name: e.nameAr,
                          //           ),
                          //         ))
                          //     .toList()
                        ],
                      ),
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
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: CustomTextButton.orangeContinue(
        width: width - 30,
        text: localizations.continue_,
        callback: () {
          if (buttonActive) {
            final item = itemManager.hasItemInSearchedItems();

            creatingManager.setTitle(productsController.text);

            creatingManager.setItem(
              item,
              name: productsController.text,
              id: item?.id,
            );

            Navigator.pushNamed(context, AppRoutesNames.announcementCreatingDescription);
          }
        },
        active: buttonActive,
      ),
    );
  }

  void _setTitle(String keywordName) {
    // String title = productsController.text.trimRight();
    // List<String> titleWords = title.split(' ');
    // if (titleWords.isNotEmpty) {
    //   titleWords.removeLast();
    // }
    // title = '${titleWords.join(' ')} $keywordName';
    // productsController.text = title;
    productsController.text = keywordName;
    setState(() {});
  }
}
