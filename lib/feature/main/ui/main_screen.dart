import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/home/bloc/scroll/scroll_cubit.dart';
import 'package:smart/feature/main/bloc/search/search_announcements_cubit.dart';
import 'package:smart/feature/main/ui/sections/categories_section.dart';
import 'package:smart/feature/main/ui/widgets/appbar_with_search_field.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/feature/search/ui/bottom_sheets/filter_bottom_sheet_dialog.dart';
import 'package:smart/feature/search/ui/sections/popular_queries.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/constants.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/scaffold/main_scaffold.dart';

import '../../../managers/announcement_manager.dart';
import '../../../widgets/conatainers/advertisement_containers.dart';
import '../../../widgets/conatainers/announcement_container.dart';
import '../../search/bloc/search_announcement_cubit.dart';
import '../bloc/announcements/announcements_cubit.dart';
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
    _initScrollListener();
  }

  void _initScrollListener() {
    _controller.addListener(() async {
      final announcementRepository = RepositoryProvider.of<AnnouncementManager>(context);
      if (announcementRepository.announcements.isNotEmpty) {
        if (_controller.position.atEdge) {
          double maxScroll = _controller.position.maxScrollExtent;
          double currentScroll = _controller.position.pixels;
          if (currentScroll >= maxScroll * 0.8) {
            BlocProvider.of<AnnouncementsCubit>(context).loadAnnounces(false);
          }
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
    final announcementRepository = RepositoryProvider.of<AnnouncementManager>(context);

    Widget getAnnouncementsGrid() {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          crossAxisSpacing: AppSizes.anouncementGridCrossSpacing,
          mainAxisSpacing: AppSizes.anouncementGridMainSpacing,
          maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
          childAspectRatio: AppSizes.anouncementAspectRatio(context),
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => AnnouncementContainer(announcement: announcementRepository.announcements[index]),
          childCount: announcementRepository.announcements.length,
        ),
      );
    }

    void openSearchScreen({
      required String? query,
      required bool showKeyboard,
    }) {
      final subcategoriesCubit = context.read<SearchSelectSubcategoryCubit>();
      final searchCubit = context.read<SearchAnnouncementCubit>();
      searchCubit.setSubcategory(null);
      searchCubit.setSearchMode(SearchModeEnum.simple);

      subcategoriesCubit.getSubcategoryFilters('').then((value) => searchCubit.searchAnnounces(
            searchText: '',
            isNew: true,
            showLoading: true,
            parameters: [],
          ));

      BlocProvider.of<PopularQueriesCubit>(context).loadPopularQueries();
      // BlocProvider.of<SearchAnnouncementCubit>(context).searchAnnounces(
      //   searchText: '',
      //   isNew: true,
      //   showLoading: false,
      // );
      Navigator.pushNamed(
        context,
        AppRoutesNames.search,
        arguments: {
          'query': query,
          'backButton': false,
          'showKeyboard': showKeyboard,
        },
      ).then((value) {
        BlocProvider.of<SearchItemsCubit>(context).searchKeywords(
          query: '',
          subcategoryId: '',
        );
      });
    }

    void openFilters() {
      openSearchScreen(query: null, showKeyboard: true);
      context.read<SearchAnnouncementCubit>().setSearchMode(SearchModeEnum.simple);
      showFilterBottomSheet(context: context);
    }

    return BlocListener<ScrollCubit, ScrollState>(
      listener: (context, state) {
        if (state is ScrollToTop) {
          _controller.animateTo(
            0,
            duration: Durations.medium2,
            curve: Curves.bounceInOut,
          );
        }
      },
      child: MainScaffold(
        canPop: false,
        appBar: AppBar(
          backgroundColor: AppColors.appBarColor,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: MainAppBar(
            isSearch: isSearch,
            openSearchScreen: () => openSearchScreen(query: null, showKeyboard: true),
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
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: PopularQueriesWidget(
                        onSearch: (e) {
                          openSearchScreen(query: e, showKeyboard: false);
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
                          '$serviceProtocol$serviceDomain/v1/storage/buckets/661d74e7000bc76c563f/files/main_ad/view?project=65d8fa703a95c4ef256b&mode=admin',
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.recommendations,
                            textAlign: TextAlign.center,
                            style: AppTypography.font20black,
                          ),
                          // Text(AppLocalizations.of(context)!.viewAll,
                          //     style: AppTypography.font14lightGray
                          //         .copyWith(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.anouncementGridSidePadding,
                    ),
                    sliver: getAnnouncementsGrid(),
                  ),
                  // if (state is AnnouncementsLoadingState) ...[
                  //   SliverToBoxAdapter(
                  //     child: SingleChildScrollView(
                  //       child: Shimmer.fromColors(
                  //         baseColor: Colors.grey[300]!,
                  //         highlightColor: Colors.grey[100]!,
                  //         child: Center(
                  //           child: Wrap(
                  //             spacing: AppSizes.anouncementGridCrossSpacing,
                  //             runSpacing: AppSizes.anouncementRunSpacing,
                  //             children: const [
                  //               AnnouncementShimmer(),
                  //               AnnouncementShimmer(),
                  //               AnnouncementShimmer(),
                  //               AnnouncementShimmer(),
                  //               AnnouncementShimmer(),
                  //               AnnouncementShimmer(),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   )
                  // ],
                  if (announcementRepository.announcements.length >= 20)
                    SliverToBoxAdapter(
                      child: Center(
                        child: SizedBox(
                          height: 200,
                          child: AppAnimations.bouncingLine,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
