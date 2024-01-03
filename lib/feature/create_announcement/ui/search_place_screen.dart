import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/places_search/places_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../../../managers/creating_announcement_manager.dart';
import '../../../managers/places_manager.dart';
import '../../../utils/animations.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../../widgets/category/products.dart';
import '../../../widgets/textField/outline_text_field.dart';

class SearchPlaceScreen extends StatefulWidget {
  const SearchPlaceScreen({super.key});

  @override
  State<SearchPlaceScreen> createState() => _SearchPlaceScreenState();
}

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {
  final placeController = TextEditingController();
  bool isTouch = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final creatingAnnouncementManager =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);

    final placeManager = RepositoryProvider.of<PlacesManager>(context);

    final cubit = BlocProvider.of<PlacesCubit>(context);

    placeController.text = cubit.getSearchText();
    placeController.selection = TextSelection.fromPosition(
        TextPosition(offset: placeController.text.length));

    final width = MediaQuery.of(context).size.width;

    void setIsTouch(bool isT) {
      isTouch = isT;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        backgroundColor: AppColors.empty,
        elevation: 0,
        title: Text(
          'Place',
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
              controller: placeController,
              height: 55,
              hintText: '',
              width: double.infinity,
              onChange: (value) {
                BlocProvider.of<PlacesCubit>(context).searchPlaces(value);
                setIsTouch(placeManager.searchPlaceIdByName(value) != null);
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
            BlocBuilder<PlacesCubit, PlacesState>(
              builder: (context, state) {
                if (state is PlacesSuccessState ||
                    state is PlacesLoadingState) {
                  return Wrap(
                    children: cubit
                        .getPlaces()
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(3),
                              child: ProductWidget(
                                onTap: () {
                                  cubit.setPlaceName(e.name);
                                  creatingAnnouncementManager
                                      .setPlaceById(e.id);
                                  setIsTouch(true);
                                  setState(() {});
                                },
                                name: e.name,
                              ),
                            ))
                        .toList(),
                  );
                } else if (state is PlacesEmptyState) {
                  return const Center(
                    child: Text('ниче не найдено'),
                  );
                } else if (state is PlacesFailState) {
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
            creatingAnnouncementManager.setPlaceById(
                placeManager.searchPlaceIdByName(placeController.text)!);
            creatingAnnouncementManager
                .setTitle(creatingAnnouncementManager.buildTitle);
            Navigator.pushNamed(
                context, AppRoutesNames.announcementCreatingDescription);
          }
        },
        active: isTouch,
      ),
    );
  }
}
