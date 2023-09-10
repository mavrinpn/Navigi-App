import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart/feature/favorites/bloc/favourites_cubit.dart';
import 'package:smart/managers/favourits_manager.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/widgets/conatainers/announcement.dart';

import '../../utils/utils.dart';

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

    List<Announcement> screenSelection = [];

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {favouritesManager.getFavourites();},
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
          body: CustomScrollView(
            slivers: [
              BlocBuilder<FavouritesCubit, FavouritesState>(
                builder: (context, state) {
                  if (state is FavouritesLoadingState) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: AppAnimations.bouncingLine,
                      ),
                    );
                  }
                  return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Container(
                          color: AppColors.mainBackground,
                          child: Center(
                            child: AnnouncementContainer(
                                announcement:
                                    favouritesManager.announcements[index]),
                          ),
                        ),
                        childCount: screenSelection.length,
                      ),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 16,
                          maxCrossAxisExtent:
                              MediaQuery.of(context).size.width / 2,
                          childAspectRatio: 160 / 272));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
