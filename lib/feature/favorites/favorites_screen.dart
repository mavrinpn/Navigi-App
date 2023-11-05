import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart/feature/favorites/bloc/favourites_cubit.dart';
import 'package:smart/managers/favourites_manager.dart';
import 'package:smart/widgets/conatainers/announcement.dart';

import '../../utils/utils.dart';
import '../../widgets/button/custom_text_button.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreen();
}

class _FavoritesScreen extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final favouritesManager = RepositoryProvider.of<FavouritesManager>(context);

    final controller = ScrollController();

    return RefreshIndicator(
      onRefresh: () async {
        favouritesManager.getFavourites();
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.mainBackground,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Favoris', style: AppTypography.font20black),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: BlocBuilder<FavouritesCubit, FavouritesState>(
                builder: (context, state) {
                  if (state is FavouritesLoadingState) {
                    return Center(
                      child: AppAnimations.bouncingLine,
                    );
                  }
                  return favouritesManager.announcements.isNotEmpty
                      ? CustomScrollView(
                          controller: controller,
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverGrid(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => Container(
                                    color: AppColors.mainBackground,
                                    child: Center(
                                      child: AnnouncementContainer(
                                          announcement: favouritesManager
                                              .announcements[index]),
                                    ),
                                  ),
                                  childCount:
                                      favouritesManager.announcements.length,
                                ),
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        crossAxisSpacing: 18,
                                        mainAxisSpacing: 16,
                                        maxCrossAxisExtent:
                                            MediaQuery.of(context).size.width / 2,
                                        childAspectRatio: 160 / 272)),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                    'Vous n\'aver pas de produits sélectionnés'),
                                const SizedBox(height: 14),
                                CustomTextButton.orangeContinue(
                                    callback: () {},
                                    text: 'aller au répertoire',
                                    isTouch: true)
                              ],
                            ),
                          ),
                        );
                },
              ),
            )),
      ),
    );
  }
}
