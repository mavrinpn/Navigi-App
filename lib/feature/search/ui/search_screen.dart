import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/feature/search/bloc/update_appbar_filter/update_appbar_filter_cubit.dart';
import 'package:smart/feature/search/ui/bottom_sheets/filter_keys.dart';
import 'package:smart/feature/search/ui/sections/history.dart';
import 'package:smart/feature/search/ui/sections/popular_queries.dart';
import 'package:smart/feature/search/ui/sections/search_items.dart';
import 'package:smart/feature/search/ui/widgets/chips/filter_chip_widget.dart';
import 'package:smart/feature/search/ui/widgets/chips/mark_chip_widget.dart';
import 'package:smart/feature/search/ui/widgets/search_appbar.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/main.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/widgets/button/back_button.dart';

import '../../../managers/announcement_manager.dart';
import '../../../managers/search_manager.dart';
import '../../../utils/animations.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/conatainers/announcement_container.dart';
import '../../main/bloc/popularQueries/popular_queries_cubit.dart';
import '../../main/bloc/search/search_announcements_cubit.dart';
import '../bloc/search_announcement_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.showBackButton,
    required this.title,
    required this.showSearchHelper,
    this.searchQueryString,
  });

  final bool showBackButton;
  final bool showSearchHelper;
  final String title;
  final String? searchQueryString;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  final _controller = ScrollController();
  String? searchQueryString;
  bool _showFilterChips = true;

  @override
  void initState() {
    super.initState();
    final searchManager = RepositoryProvider.of<SearchManager>(context);
    searchManager.setSearch(widget.showSearchHelper);
    searchQueryString = widget.searchQueryString;

    // _controller.addListener(() async {
    //   if (_controller.position.atEdge) {
    //     double maxScroll = _controller.position.maxScrollExtent;
    //     double currentScroll = _controller.position.pixels;
    //     if (currentScroll >= maxScroll * 0.8) {
    //       BlocProvider.of<SearchAnnouncementCubit>(context).searchAnnounces(
    //         searchText: '',
    //         isNew: false,
    //       );
    //     }
    //   }
    // });
  }

  @override
  void didChangeDependencies() {
    context.watch<SearchSelectSubcategoryCubit>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setSearchText(String text) {
    searchController.text = text;
  }

  void setSearch(String query, SearchManager? searchManager) {
    BlocProvider.of<SearchAnnouncementCubit>(context).searchAnnounces(
      searchText: query,
      isNew: true,
    );
    searchManager?.setSearch(false);
    setSearchText(query);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final searchManager = RepositoryProvider.of<SearchManager>(context);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context)!;
    final announcementRepository =
        RepositoryProvider.of<AnnouncementManager>(context);

    searchController.selection = TextSelection(
        baseOffset: searchController.text.length,
        extentOffset: searchController.text.length);

    Widget announcementGridBuilder(BuildContext context, int index) {
      return AnnouncementContainer(
        announcement: announcementRepository.searchAnnouncements[index],
      );
    }

    SliverGridDelegateWithMaxCrossAxisExtent gridDelegate =
        SliverGridDelegateWithMaxCrossAxisExtent(
      crossAxisSpacing: 10,
      mainAxisSpacing: 15,
      maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
      childAspectRatio: 160 / 272,
    );

    AppBar searchAppBar = AppBar(
      backgroundColor: AppColors.mainBackground,
      automaticallyImplyLeading: false,
      elevation: 0,
      titleSpacing: 0,
      clipBehavior: Clip.none,
      bottom: !widget.showBackButton
          ? _buildCategoryAppBarBottom(_showFilterChips)
          : null,
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SearchAppBar(
              showBackButton: widget.showBackButton,
              onSubmitted: (String? value) {
                setState(() {
                  _showFilterChips = true;
                });

                searchManager.setSearch(false);
                searchManager.saveInHistory(value!);
                setState(() {});
                BlocProvider.of<SearchAnnouncementCubit>(context)
                    .searchAnnounces(
                  searchText: value,
                  isNew: true,
                  parameters:
                      context.read<SearchSelectSubcategoryCubit>().parameters,
                );
              },
              onChange: (String value) {
                searchManager.setSearch(true);
                setState(() {});
                BlocProvider.of<SearchItemsCubit>(context).search(value);
                BlocProvider.of<PopularQueriesCubit>(context)
                    .loadPopularQueries();
              },
              onTap: () {
                setState(() {
                  _showFilterChips = false;
                });
              },
              searchController: searchController,
            ),
          ),
        ],
      ),
    );

    Widget searchScreenBuilder(context, state) {
      if (state is SearchItemsSuccess &&
          searchController.text.isNotEmpty &&
          state.result.isNotEmpty) {
        return SearchItemsWidget(state: state, setSearch: setSearch);
      } else if (state is SearchItemsLoading) {
        return Center(child: AppAnimations.bouncingLine);
      }
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              localizations.popularResearch,
              style: AppTypography.font14black
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          PopularQueriesWidget(
            onSearch: (e) {
              setSearch(e, searchManager);
              searchManager.saveInHistory(e);
            },
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.researchHistory,
                style: AppTypography.font14black
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                localizations.toClean,
                style: AppTypography.font12lightGray
                    .copyWith(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(height: 7),
          HistoryWidget(
            onDelete: (e) {
              searchManager.deleteQueryByName(e);
              setState(() {});
            },
            onSearch: (e) {
              setSearch(e.toString(), searchManager);
            },
          )
        ],
      );
    }

    Widget gridBuild() {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        sliver: SliverGrid(
          gridDelegate: gridDelegate,
          delegate: SliverChildBuilderDelegate(
            announcementGridBuilder,
            childCount: announcementRepository.searchAnnouncements.length,
          ),
        ),
      );
    }

    Widget announcementsBuilder(context, state) {
      if (announcementRepository.searchAnnouncements.isNotEmpty) {}

      if (state is SearchAnnouncementsFailState ||
          announcementRepository.searchAnnouncements.isEmpty) {
        return Center(
          child: Text(AppLocalizations.of(context)!.empty),
        );
      }

      return CustomScrollView(
        controller: _controller,
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast),
        slivers: [
          gridBuild(),
          if (state is SearchAnnouncementsLoadingState) ...[
            SliverToBoxAdapter(
              child: Center(child: AppAnimations.bouncingLine),
            )
          ]
        ],
      );
    }

    return Container(
      color: AppColors.mainBackground,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.mainBackground,
          appBar: searchAppBar,
          body: Stack(
            children: [
              BlocConsumer<SearchAnnouncementCubit, SearchAnnouncementState>(
                listener: (context, state) {
                  if (state is SearchAnnouncementsSuccessState) {
                    if (searchQueryString != null) {
                      setSearch(
                        searchQueryString!,
                        searchManager,
                      );
                      searchQueryString = null;
                    }
                  }
                },
                builder: (context, state) {
                  return BlocBuilder<SearchAnnouncementCubit,
                      SearchAnnouncementState>(
                    builder: announcementsBuilder,
                  );
                },
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: width,
                      curve: Curves.fastOutSlowIn,
                      height: searchManager.isSearch ? height : 0,
                      color: Colors.white,
                      padding: const EdgeInsets.all(15),
                      child: SingleChildScrollView(
                        child: BlocBuilder<SearchItemsCubit, SearchItemsState>(
                          builder: searchScreenBuilder,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCategoryAppBarBottom(bool showFilterChips) {
    return PreferredSize(
      preferredSize: Size.fromHeight(showFilterChips ? 90 : 44),
      child: BlocBuilder<UpdateAppBarFilterCubit, UpdateAppBarFilterState>(
        builder: (context, state) {
          final localizations = AppLocalizations.of(context)!;
          final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);
          final selectCategoryCubit =
              BlocProvider.of<SearchSelectSubcategoryCubit>(context);

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CustomBackButton(),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (showFilterChips)
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 6,
                      children: [
                        FilterChipWidget(
                          isSelected: !(searchCubit.minPrice == null &&
                              searchCubit.maxPrice == null),
                          title: localizations.price,
                          parameterKey: FilterKeys.price,
                        ),
                        FilterChipWidget(
                          isSelected: searchCubit.areaId != null ||
                              searchCubit.cityId != null,
                          title: localizations.location,
                          parameterKey: FilterKeys.location,
                        ),
                        if (selectCategoryCubit.subcategoryFilters?.hasMark ??
                            false)
                          const MarkChipWidget(),
                        ...selectCategoryCubit.parameters.map((parameter) {
                          bool isSelected = false;
                          if (parameter is SelectParameter) {
                            isSelected = parameter.selectedVariants.isNotEmpty;
                          } else if (parameter is SingleSelectParameter) {
                            isSelected = parameter.selectedVariants.isNotEmpty;
                          } else if (parameter is MultiSelectParameter) {
                            isSelected = parameter.selectedVariants.isNotEmpty;
                          } else if (parameter is MinMaxParameter) {
                            isSelected =
                                parameter.min != null || parameter.max != null;
                          }

                          return FilterChipWidget(
                            isSelected: isSelected,
                            title: MyApp.getLocale(context) == 'fr'
                                ? parameter.frName
                                : parameter.arName,
                            parameterKey: parameter.key,
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
