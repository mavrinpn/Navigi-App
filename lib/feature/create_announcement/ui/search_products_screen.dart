import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/utils/animations.dart';
import '../../../managers/creating_announcement_manager.dart';
import '../../../managers/item_manager.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../../widgets/category/products.dart';
import '../../../widgets/textField/outline_text_field.dart';
import '../bloc/item_search/item_search_cubit.dart';


import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    final creatingAnnouncementManager =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);
    final itemManager =
        RepositoryProvider.of<ItemManager>(context);

    final cubit = BlocProvider.of<ItemSearchCubit>(context);

    productsController.text = cubit.getSearchText();
    productsController.selection = TextSelection.fromPosition(
        TextPosition(offset: productsController.text.length));
    final width = MediaQuery.of(context).size.width;

    bool isTouch = cubit.getSearchText().isNotEmpty;

    void setIsTouch(bool isT) {
      isTouch = isT;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        backgroundColor: AppColors.empty,
        elevation: 0,
        title: Text(
          'Indiquez le nom',
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
                'Requêtes populaires',
                style: AppTypography.font16black.copyWith(fontSize: 14),
              ),
            ),
            BlocBuilder<ItemSearchCubit, ItemSearchState>(
              builder: (context, state) {
                if (state is SearchSuccessState ||
                    state is SearchLoadingState) {
                  return Wrap(
                    children: cubit.getItems()
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(3),
                              child: ProductWidget(
                                onTap: () {
                                  cubit.setItemName(e.name);
                                  creatingAnnouncementManager.setItem(e);
                                  setState(() {});
                                },
                                name: e.name,
                              ),
                            ))
                        .toList(),
                  );
                } else if (state is SearchEmptyState) {
                  return const Center(
                    child: Text('ниче не найдено'),
                  );
                } else if (state is SearchFailState) {
                  return const Center(
                    child: Text('ошибка'),
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
        text: 'Continuer',
        callback: () {
          if (isTouch) {
            creatingAnnouncementManager.setItem(itemManager.hasItemInSearchedItems(), name: productsController.text);
            Navigator.pushNamed(context, '/create_pick_photos_screen');
          }
        },
        active: isTouch,
      ),
    );
  }
}
