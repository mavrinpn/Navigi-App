import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/favorites/bloc/favourites_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/favourites_manager.dart';
import 'package:smart/widgets/conatainers/announcement_container.dart';

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

    Widget buildAnnouncementsGrid() {
      return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              color: AppColors.mainBackground,
              child: AnnouncementContainer(announcement: favouritesManager.announcements[index]),
            ),
            childCount: favouritesManager.announcements.length,
          ),
          //TODO
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
              childAspectRatio: 160 / 272));
    }

    return RefreshIndicator(
      onRefresh: () async {
        favouritesManager.getFavourites();
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.appBarColor,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(localizations.favourites, style: AppTypography.font20black),
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
                          slivers: [buildAnnouncementsGrid()],
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(localizations.dontHaveProducts),
                                const SizedBox(height: 14),
                                CustomTextButton.orangeContinue(
                                    callback: () {}, text: localizations.goRepertoire, active: true)
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
