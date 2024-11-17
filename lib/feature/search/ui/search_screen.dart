import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/feature/search/bloc/update_appbar_filter/update_appbar_filter_cubit.dart';
import 'package:smart/feature/search/ui/bottom_sheets/filter_bottom_sheet_dialog.dart';
import 'package:smart/feature/search/ui/bottom_sheets/filter_keys.dart';
import 'package:smart/feature/search/ui/sections/history.dart';
import 'package:smart/feature/search/ui/sections/popular_queries.dart';
import 'package:smart/feature/search/ui/sections/search_items.dart';
import 'package:smart/feature/search/ui/widgets/announcement_shimmer.dart';
import 'package:smart/feature/search/ui/widgets/chips/filter_chip_widget.dart';
import 'package:smart/feature/search/ui/widgets/chips/mark_chip_widget.dart';
import 'package:smart/feature/search/ui/widgets/search_appbar.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/main.dart';
import 'package:smart/managers/categories_manager.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/models/key_word.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/button/back_button.dart';
import 'package:smart/widgets/snackBar/snack_bar.dart';

import '../../../managers/announcement_manager.dart';
import '../../../managers/search_manager.dart';
import '../../../widgets/conatainers/announcement_container.dart';
import '../../main/bloc/popularQueries/popular_queries_cubit.dart';
import '../../main/bloc/search/search_announcements_cubit.dart';
import '../bloc/search_announcement_cubit.dart';

// final GlobalKey<FormFieldState<String>> searchScreenTextControllerKey = GlobalKey<FormFieldState<String>>();
final searchScreenTextController = TextEditingController();

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.showBackButton,
    required this.title,
    required this.showSearchHelper,
    required this.showKeyboard,
    required this.showCancelButton,
    required this.showFilterChips,
    this.searchQueryString,
    required this.isSubcategory,
  });

  final bool showBackButton;
  final bool showSearchHelper;
  final bool showKeyboard;
  final bool showCancelButton;
  final bool showFilterChips;

  final String title;
  final bool isSubcategory;
  final String? searchQueryString;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // late StreamSubscription<InternetStatus> _internetConnectionSubscription;
  final _controller = ScrollController();
  final FocusNode _focusNode = FocusNode();
  String? searchQueryString;
  bool _showFilterChips = true;
  bool _showCancelButton = true;
  bool _showBackButton = true;
  String lastQuery = '';
  String title = '';

  KeyWord? selectedKeyword;
  List<KeyWord> searchedKeywords = [];

  bool isScrollLoading = false;
  final _searchAppBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    title = widget.title;
    _showFilterChips = widget.showFilterChips;
    _showCancelButton = widget.showCancelButton;
    _showBackButton = widget.showBackButton;
    final searchManager = RepositoryProvider.of<SearchManager>(context);
    searchManager.setSearch(widget.showSearchHelper);

    searchQueryString = widget.searchQueryString;
    if (searchQueryString != null) {
      searchScreenTextController.text = searchQueryString!;
    }

    _controller.addListener(() async {
      if (_controller.offset > 100 && _controller.position.maxScrollExtent < _controller.offset + 250) {
        if (!isScrollLoading) {
          isScrollLoading = true;

          if (selectedKeyword != null) {
            BlocProvider.of<SearchAnnouncementCubit>(context).searchAnnouncesByKeyword(
              keyword: selectedKeyword!,
              isNew: false,
            );
          } else {
            BlocProvider.of<SearchAnnouncementCubit>(context).searchAnnounces(
              searchText: lastQuery,
              isNew: false,
              showLoading: false,
            );
          }
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showKeyboard) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  @override
  dispose() {
    searchScreenTextController.text = '';
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    context.watch<SearchSelectSubcategoryCubit>();
    super.didChangeDependencies();
  }

  void setSearchText(String text) {
    searchScreenTextController.text = text;
  }

  void setSearch(String query, SearchManager? searchManager) {
    searchManager?.saveInHistory(query);

    selectedKeyword = null;
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

    searchScreenTextController.selection = TextSelection(
        baseOffset: searchScreenTextController.text.length, extentOffset: searchScreenTextController.text.length);

    SliverGridDelegateWithMaxCrossAxisExtent gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
      crossAxisSpacing: AppSizes.anouncementGridCrossSpacing,
      mainAxisSpacing: AppSizes.anouncementGridMainSpacing,
      maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
      childAspectRatio: AppSizes.anouncementAspectRatio(context),
    );

    AppBar searchAppBar = AppBar(
      backgroundColor: AppColors.appBarColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      clipBehavior: Clip.none,
      bottom: _buildCategoryAppBarBottom(_showFilterChips, !_showBackButton && !_showCancelButton),
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SearchAppBar(
              key: _searchAppBarKey,
              showBackButton: _showBackButton,
              showFilter: _showFilterChips,
              showCancelAction: _showCancelButton,
              onCancelAction: () {
                if (widget.isSubcategory) {
                  FocusScope.of(context).unfocus();
                  searchManager.setSearch(false);
                  setState(() {
                    _showFilterChips = true;
                    _showCancelButton = false;
                    _showBackButton = true;
                  });
                } else {
                  Navigator.of(context).pop();
                }
              },
              onSubmitted: (String? value) {
                final keywordIndex = searchedKeywords.indexWhere((item) =>
                    item.nameAr.toLowerCase() == value?.toLowerCase() ||
                    item.nameFr.toLowerCase() == value?.toLowerCase());
                if (keywordIndex != -1) {
                  _onKeywordTap(searchedKeywords[keywordIndex]);
                  return;
                }

                _showFilterChips = true;
                _showCancelButton = false;
                _showBackButton = true;

                searchManager.setSearch(false);
                searchManager.saveInHistory(value!);
                setState(() {});

                selectedKeyword = null;
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
                  _showCancelButton = true;
                  _showBackButton = false;
                });
              },
              searchController: searchScreenTextController,
              searchControllerKey: null,
              focusNode: _focusNode,
              autofocus: false,
            ),
          ),
        ],
      ),
    );

    Widget searchScreenBuilder(context, state) {
      //if (state is SearchItemsSuccess && searchController.text.isNotEmpty && state.result.isNotEmpty) {
      if (state is SearchItemsSuccess) {
        searchedKeywords = state.result;
        return SearchItemsWidget(
          state: state,
          onCurrentQueryTap: (currentQuery) {
            setSearch(
              currentQuery,
              searchManager,
            );
          },
          onKeywordTap: (keyword) {
            _onKeywordTap(keyword);
          },
        );
      } else if (searchQueryString != null || state is SearchItemsLoading) {
        searchedKeywords.clear();
        // return Center(child: AppAnimations.bouncingLine);
        return const SizedBox.shrink();
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

    Widget announcementsBuilder(context, state) {
      final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);

      if (state is SearchAnnouncementsLoadingState && !isScrollLoading) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(top: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Center(
              child: Wrap(
                spacing: AppSizes.anouncementGridCrossSpacing,
                runSpacing: AppSizes.anouncementRunSpacing,
                children: const [
                  AnnouncementShimmer(),
                  AnnouncementShimmer(),
                  AnnouncementShimmer(),
                  AnnouncementShimmer(),
                  AnnouncementShimmer(),
                  AnnouncementShimmer(),
                ],
              ),
            ),
          ),
        );
      }

      if (state is SearchAnnouncementsFailState ||
          announcementRepository.searchAnnouncementsWithExactLocation.length +
                  announcementRepository.searchAnnouncementsWithOtherLocation.length ==
              0) {
        if (state is SearchAnnouncementsFailState) {
          CustomSnackBar.showSnackBar(context, state.error, 10);
        }
        return Center(
          child: Text(AppLocalizations.of(context)!.empty),
        );
      }

      return RefreshIndicator(
        color: AppColors.red,
        onRefresh: () async {
          if (selectedKeyword != null) {
            BlocProvider.of<SearchAnnouncementCubit>(context).searchAnnouncesByKeyword(
              keyword: selectedKeyword!,
              isNew: true,
            );
          } else {
            BlocProvider.of<SearchAnnouncementCubit>(context).searchAnnounces(
              searchText: lastQuery,
              isNew: true,
              showLoading: false,
              parameters: context.read<SearchSelectSubcategoryCubit>().parameters,
            );
          }
        },
        child: CustomScrollView(
          controller: _controller,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
          slivers: [
            if (announcementRepository.searchAnnouncementsWithExactLocation.isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.anouncementGridSidePadding,
                  vertical: AppSizes.anouncementGridSidePadding,
                ),
                sliver: SliverGrid(
                  gridDelegate: gridDelegate,
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => AnnouncementContainer(
                      announcement: announcementRepository.searchAnnouncementsWithExactLocation[index],
                    ),
                    childCount: announcementRepository.searchAnnouncementsWithExactLocation.length,
                  ),
                ),
              ),

            if (announcementRepository.searchAnnouncementsWithOtherLocation.isNotEmpty &&
                (searchCubit.areaId != null || searchCubit.cityId != null))
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.anouncementGridSidePadding,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('Assets/search_other_city.jpg'),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.otherCity,
                        style: AppTypography.font20black,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            if (announcementRepository.searchAnnouncementsWithOtherLocation.isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.anouncementGridSidePadding,
                  vertical: AppSizes.anouncementGridSidePadding,
                ),
                sliver: SliverGrid(
                  gridDelegate: gridDelegate,
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => AnnouncementContainer(
                      announcement: announcementRepository.searchAnnouncementsWithOtherLocation[index],
                    ),
                    childCount: announcementRepository.searchAnnouncementsWithOtherLocation.length == 1
                        ? 1
                        : announcementRepository.searchAnnouncementsWithOtherLocation.length % 2 == 0
                            ? announcementRepository.searchAnnouncementsWithOtherLocation.length
                            : announcementRepository.searchAnnouncementsWithOtherLocation.length - 1,
                  ),
                ),
              ),
            if (state is SearchAnnouncementsLoadingState &&
                announcementRepository.searchAnnouncementsWithExactLocation.length +
                        announcementRepository.searchAnnouncementsWithOtherLocation.length >=
                    20)
              SliverToBoxAdapter(
                child: Center(
                  child: SizedBox(
                    height: 100,
                    child: AppAnimations.bouncingLine,
                  ),
                ),
              ),
            // ]
          ],
        ),
      );
    }

    return Container(
      color: AppColors.mainBackground,
      child: SafeArea(
        child: PopScope(
          onPopInvokedWithResult: (_, __) async {
            final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);
            final selectCategoryCubit = BlocProvider.of<SearchSelectSubcategoryCubit>(context);
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

            final updateAppBarFilterCubit = context.read<UpdateAppBarFilterCubit>();
            updateAppBarFilterCubit.needUpdateAppBarFilters();
          },
          child: Scaffold(
            backgroundColor: AppColors.mainBackground,
            appBar: searchAppBar,
            body: Stack(
              children: [
                BlocConsumer<SearchAnnouncementCubit, SearchAnnouncementState>(
                  listener: (context, state) {
                    if (state is SearchAnnouncementsSuccessState) {
                      isScrollLoading = false;
                      if (searchQueryString != null) {
                        setSearch(
                          searchQueryString!,
                          searchManager,
                        );
                        searchQueryString = null;
                      }
                    }
                  },
                  builder: announcementsBuilder,
                  // builder: (context, state) {
                  //   return BlocBuilder<SearchAnnouncementCubit, SearchAnnouncementState>(
                  //     builder: announcementsBuilder,
                  //   );
                  // },
                ),
                SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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

  void _onKeywordTap(KeyWord keyword) {
    final searchManager = RepositoryProvider.of<SearchManager>(context);

    _showFilterChips = true;
    _showCancelButton = false;
    _showBackButton = true;

    final query = keyword.localizedName();

    final subcategoriesCubit = BlocProvider.of<SearchSelectSubcategoryCubit>(context);
    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);
    final subcategory = CategoriesManager.subcategory(keyword.subcategoryId);
    searchCubit.setSubcategory(subcategory);
    searchCubit.setSearchMode(SearchModeEnum.subcategory);
    subcategoriesCubit.getSubcategoryFilters(keyword.subcategoryId);

    selectedKeyword = keyword;
    BlocProvider.of<SearchAnnouncementCubit>(context).searchAnnouncesByKeyword(
      keyword: keyword,
      isNew: true,
    );
    lastQuery = query;
    searchManager.setSearch(false);
    setSearchText(query);

    RepositoryProvider.of<SearchManager>(context).setSearch(false);
    BlocProvider.of<PopularQueriesCubit>(context).loadPopularQueries();

    // title = subcategory?.localizedName() ?? '';
    // _showBackButton = false;

    setState(() {});

    FocusScope.of(context).unfocus();
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

          title = state.title ?? title;

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
                    Expanded(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showFilterBottomSheet(
                          context: context,
                          parameterKey: FilterKeys.location,
                          needOpenNewScreen: false,
                        );
                      },
                      child: Text(_cityName(context)),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              if (showFilterChips)
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 6,
                        children: [
                          FilterChipWidget(
                            isSelected: selectCategoryCubit.subcategoryId != null &&
                                selectCategoryCubit.subcategoryId!.isNotEmpty,
                            title: localizations.category,
                            parameterKey: FilterKeys.subcategory,
                          ),
                          FilterChipWidget(
                            isSelected: !(searchCubit.minPrice == null && searchCubit.maxPrice == null),
                            title: localizations.price,
                            parameterKey: FilterKeys.price,
                          ),
                          if (selectedKeyword != null ||
                              selectCategoryCubit.subcategoryId == null ||
                              selectCategoryCubit.subcategoryId!.isEmpty)
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
                                isSelected = parameter.currentValue.key != emptyParameter;
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

  String _cityName(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);
    String name = localizations.location;

    if (searchCubit.cityTitle != null) {
      name = searchCubit.cityTitle!;
    }

    if (searchCubit.distrinctTitle != null) {
      name += ' / ${searchCubit.distrinctTitle}';
    }

    return name;
  }
}
