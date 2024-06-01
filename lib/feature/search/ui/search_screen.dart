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
import 'package:smart/widgets/snackBar/snack_bar.dart';

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
    required this.showKeyboard,
    this.searchQueryString,
  });

  final bool showBackButton;
  final bool showSearchHelper;
  final bool showKeyboard;
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
  String lastQuery = '';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _showFilterChips = !widget.showBackButton;
    final searchManager = RepositoryProvider.of<SearchManager>(context);
    searchManager.setSearch(widget.showSearchHelper);
    searchQueryString = widget.searchQueryString;

    _controller.addListener(() async {
      if (_controller.position.maxScrollExtent < _controller.offset + 250) {
        if (!isLoading) {
          isLoading = true;
          BlocProvider.of<SearchAnnouncementCubit>(context).searchAnnounces(
            searchText: lastQuery,
            isNew: false,
            showLoading: false,
          );
        }
      }
      // if (_controller.position.atEdge) {
      //   double maxScroll = _controller.position.maxScrollExtent;
      //   double currentScroll = _controller.position.pixels;
      //   if (currentScroll >= maxScroll * 0.5) {
      //     print('searchAnnounces');
      //     BlocProvider.of<SearchAnnouncementCubit>(context).searchAnnounces(
      //       searchText: lastQuery,
      //       isNew: false,
      //       showLoading: false,
      //     );
      //   }
      // }
    });
  }

  @override
  void didChangeDependencies() {
    context.watch<SearchSelectSubcategoryCubit>();
    super.didChangeDependencies();
  }

  void setSearchText(String text) {
    searchController.text = text;
  }

  void setSearch(String query, SearchManager? searchManager) {
    searchManager?.saveInHistory(query);
    isLoading = true;
    BlocProvider.of<SearchAnnouncementCubit>(context).searchAnnounces(
      searchText: query,
      isNew: true,
      showLoading: true,
    );
    lastQuery = query;
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
    final announcementRepository = RepositoryProvider.of<AnnouncementManager>(context);

    searchController.selection =
        TextSelection(baseOffset: searchController.text.length, extentOffset: searchController.text.length);

    Widget announcementGridBuilder(BuildContext context, int index) {
      return AnnouncementContainer(
        announcement: announcementRepository.searchAnnouncements[index],
      );
    }

    SliverGridDelegateWithMaxCrossAxisExtent gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
      crossAxisSpacing: 10,
      mainAxisSpacing: 15,
      maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
      childAspectRatio: 160 / 272,
    );

    AppBar searchAppBar = AppBar(
      backgroundColor: AppColors.appBarColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      titleSpacing: 0,
      clipBehavior: Clip.none,
      //bottom: !widget.showBackButton ? _buildCategoryAppBarBottom(_showFilterChips) : null,
      bottom: _buildCategoryAppBarBottom(_showFilterChips, !widget.showBackButton),
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
                isLoading = true;
                BlocProvider.of<SearchAnnouncementCubit>(context).searchAnnounces(
                  searchText: value,
                  isNew: true,
                  showLoading: true,
                  parameters: context.read<SearchSelectSubcategoryCubit>().parameters,
                );
                lastQuery = value;
              },
              onChange: (String value) {
                searchManager.setSearch(true);
                setState(() {});
                final selectCategoryCubit = BlocProvider.of<SearchSelectSubcategoryCubit>(context);

                BlocProvider.of<SearchItemsCubit>(context).searchKeywords(
                  query: value,
                  subcategoryId: widget.showBackButton ? null : selectCategoryCubit.subcategoryId,
                );
                BlocProvider.of<PopularQueriesCubit>(context).loadPopularQueries();
              },
              onTap: () {
                searchManager.setSearch(true);
                setState(() {
                  _showFilterChips = false;
                });
              },
              searchController: searchController,
              autofocus: widget.showKeyboard,
            ),
          ),
        ],
      ),
    );

    Widget searchScreenBuilder(context, state) {
      //if (state is SearchItemsSuccess && searchController.text.isNotEmpty && state.result.isNotEmpty) {
      if (state is SearchItemsSuccess) {
        return SearchItemsWidget(
          state: state,
          onCurrentQueryTap: (currentQuery) {
            setSearch(
              currentQuery,
              searchManager,
            );
          },
          onKeywordTap: (keyword) {
            setState(() {
              _showFilterChips = true;
            });

            final String currentLocale = MyApp.getLocale(context) ?? 'fr';
            final query = currentLocale == 'fr' ? keyword.nameFr : keyword.nameAr;

            isLoading = true;
            BlocProvider.of<SearchAnnouncementCubit>(context).searchAnnouncesByKeyword(
              keyword: keyword,
              isNew: true,
            );
            lastQuery = query;
            searchManager.setSearch(false);
            setSearchText(query);
            setState(() {});

            FocusManager.instance.primaryFocus?.unfocus();
          },
        );
      } else if (searchQueryString != null || state is SearchItemsLoading) {
        return Center(child: AppAnimations.bouncingLine);
      }

      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              localizations.popularResearch,
              style: AppTypography.font14black.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          PopularQueriesWidget(
            onSearch: (e) {
              setSearch(e, searchManager);
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.researchHistory,
                style: AppTypography.font14black.copyWith(fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  searchManager.clearQuery();
                  setState(() {});
                },
                child: Text(
                  localizations.toClean,
                  style: AppTypography.font12lightGray.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                ),
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

      if (state is SearchAnnouncementsFailState || announcementRepository.searchAnnouncements.isEmpty) {
        if (state is SearchAnnouncementsFailState) {
          CustomSnackBar.showSnackBar(context, state.error, 10);
        }
        return Center(
          child: Text(AppLocalizations.of(context)!.empty),
        );
      }

      return CustomScrollView(
        controller: _controller,
        physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
        slivers: [
          gridBuild(),
          // if (state is SearchAnnouncementsScrollLoadingState) ...[
          if (announcementRepository.searchAnnouncements.length >= 20)
            SliverToBoxAdapter(
              child: Center(
                child: SizedBox(
                  height: 200,
                  child: AppAnimations.bouncingLine,
                ),
              ),
            )
          // ]
        ],
      );
    }

    return Container(
      color: AppColors.mainBackground,
      child: SafeArea(
        child: PopScope(
          onPopInvoked: (didPop) {
            final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);
            final selectCategoryCubit = BlocProvider.of<SearchSelectSubcategoryCubit>(context);
            final updateAppBarFilterCubit = context.read<UpdateAppBarFilterCubit>();
            updateAppBarFilterCubit.needUpdateAppBarFilters();
            searchCubit.clearFilters();
            selectCategoryCubit.clearFilters();
            for (var param in selectCategoryCubit.parameters) {
              if (param is SelectParameter) {
                param.selectedVariants = [];
              } else if (param is SingleSelectParameter) {
                param.currentValue = param.variants.first;
              } else if (param is MultiSelectParameter) {
                param.selectedVariants = [];
              } else if (param is MinMaxParameter) {
                param.min = null;
                param.max = null;
              }
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.mainBackground,
            appBar: searchAppBar,
            body: Stack(
              children: [
                BlocConsumer<SearchAnnouncementCubit, SearchAnnouncementState>(
                  listener: (context, state) {
                    if (state is SearchAnnouncementsSuccessState) {
                      isLoading = false;
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
                    return BlocBuilder<SearchAnnouncementCubit, SearchAnnouncementState>(
                      builder: announcementsBuilder,
                    );
                  },
                ),
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 0),
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
      ),
    );
  }

  _buildCategoryAppBarBottom(bool showFilterChips, bool showBackButton) {
    double height = 0;
    if (showFilterChips) {
      height += 46;
    }
    if (showBackButton) {
      height += 46;
    }
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: BlocBuilder<UpdateAppBarFilterCubit, UpdateAppBarFilterState>(
        builder: (context, state) {
          final localizations = AppLocalizations.of(context)!;
          final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);
          final selectCategoryCubit = BlocProvider.of<SearchSelectSubcategoryCubit>(context);

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showBackButton)
                Row(
                  children: [
                    CustomBackButton(
                      callback: () {
                        // final subcategoriesCubit = context.read<SearchSelectSubcategoryCubit>();
                        selectCategoryCubit.getSubcategoryFilters('');
                      },
                    ),
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
                    child: SizedBox(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 6,
                        children: [
                          FilterChipWidget(
                            isSelected: !(searchCubit.minPrice == null && searchCubit.maxPrice == null),
                            title: localizations.price,
                            parameterKey: FilterKeys.price,
                          ),
                          FilterChipWidget(
                            isSelected: searchCubit.areaId != null || searchCubit.cityId != null,
                            title: localizations.location,
                            parameterKey: FilterKeys.location,
                          ),
                          if (selectCategoryCubit.subcategoryId != null &&
                              selectCategoryCubit.subcategoryId!.isNotEmpty)
                            if (selectCategoryCubit.subcategoryFilters?.hasMark ?? false) const MarkChipWidget(),
                          if (selectCategoryCubit.subcategoryId != null &&
                              selectCategoryCubit.subcategoryId!.isNotEmpty)
                            ...selectCategoryCubit.parameters.map((parameter) {
                              bool isSelected = false;
                              if (parameter is SelectParameter) {
                                isSelected = parameter.selectedVariants.isNotEmpty;
                              } else if (parameter is SingleSelectParameter) {
                                isSelected = parameter.currentValue.key != null;
                              } else if (parameter is MultiSelectParameter) {
                                isSelected = parameter.selectedVariants.isNotEmpty;
                              } else if (parameter is MinMaxParameter) {
                                isSelected = parameter.min != null || parameter.max != null;
                              }
                              if (parameter is! MultiSelectParameter) {
                                return FilterChipWidget(
                                  isSelected: isSelected,
                                  title: MyApp.getLocale(context) == 'fr' ? parameter.frName : parameter.arName,
                                  parameterKey: parameter.key,
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }).toList(),
                        ],
                      ),
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
