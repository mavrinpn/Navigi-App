import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/main/ui/sections/categories_section.dart';
import 'package:smart/feature/main/ui/widgets/appbar_with_search_field.dart';
import 'package:smart/feature/search/ui/bottom_sheets/filter_bottom_sheet_dialog.dart';
import 'package:smart/feature/search/ui/sections/popular_queries.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/scaffold/main_scaffold.dart';

import '../../../managers/announcement_manager.dart';
import '../../../utils/animations.dart';
import '../../../widgets/conatainers/advertisement_containers.dart';
import '../../../widgets/conatainers/announcement_container.dart';
import '../../search/bloc/search_announcement_cubit.dart';
import '../bloc/announcements/announcement_cubit.dart';
import '../bloc/popularQueries/popular_queries_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final searchController = TextEditingController();
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    BlocProvider.of<PopularQueriesCubit>(context).loadPopularQueries();

    _controller.addListener(() async {
      if (_controller.position.atEdge) {
        double maxScroll = _controller.position.maxScrollExtent;
        double currentScroll = _controller.position.pixels;
        if (currentScroll >= maxScroll * 0.8) {
          BlocProvider.of<AnnouncementsCubit>(context).loadAnnounces(false);
        }
      }
    });
  }

  bool isSearch = false;

  void setSearch(bool f) {
    setState(() {
      isSearch = f;
    });
  }

  @override
  Widget build(BuildContext context) {
    final announcementRepository =
        RepositoryProvider.of<AnnouncementManager>(context);

    Widget getAnnouncementsGrid() {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 25,
            mainAxisSpacing: 14,
            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
            childAspectRatio: 160 / 272),
        delegate: SliverChildBuilderDelegate(
          (context, index) => AnnouncementContainer(
              announcement: announcementRepository.announcements[index]),
          childCount: announcementRepository.announcements.length,
        ),
      );
    }

    void openSearchScreen(String? query) {
      context
          .read<SearchAnnouncementCubit>()
          .setSearchMode(SearchModeEnum.simple);
      BlocProvider.of<PopularQueriesCubit>(context).loadPopularQueries();
      BlocProvider.of<SearchAnnouncementCubit>(context).searchAnnounces(
        searchText: '',
        isNew: true,
      );
      Navigator.pushNamed(
        context,
        AppRoutesNames.search,
        arguments: {'query': query, 'backButton': false},
      );
    }

    void openFilters() {
      context
          .read<SearchAnnouncementCubit>()
          .setSearchMode(SearchModeEnum.simple);
      showFilterBottomSheet(context: context);
    }

    return MainScaffold(
      canPop: false,
      appBar: AppBar(
        backgroundColor: AppColors.mainBackground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: MainAppBar(
          isSearch: isSearch,
          openSearchScreen: () => openSearchScreen(null),
          openFilters: openFilters,
          cancel: () {
            FocusScope.of(context).unfocus();
            setSearch(false);
          },
        ),
      ),
      body: BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: AppColors.red,
            onRefresh: () async {
              BlocProvider.of<AnnouncementsCubit>(context).loadAnnounces(true);
            },
            child: CustomScrollView(
              controller: _controller,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: PopularQueriesWidget(
                      onSearch: (e) {
                        openSearchScreen(e);
                      },
                    ),
                  ),
                ),
                const CategoriesSection(),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 8),
                ),
                SliverToBoxAdapter(
                  child: AdvertisementContainer(
                    onTap: () {},
                    imageUrl:
                        'https://avatars.mds.yandex.net/i?id=6deffd61630391bd9df44801831eb1ef_sr-5241446-images-thumbs&n=13',
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.recommendations,
                            textAlign: TextAlign.center,
                            style: AppTypography.font20black),
                        // Text(AppLocalizations.of(context)!.viewAll,
                        //     style: AppTypography.font14lightGray
                        //         .copyWith(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    sliver: getAnnouncementsGrid()),
                if (state is AnnouncementsLoadingState) ...[
                  SliverToBoxAdapter(
                    child: Center(child: AppAnimations.bouncingLine),
                  )
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
