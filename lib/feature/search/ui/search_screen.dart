import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/feature/search/ui/sections/history.dart';
import 'package:smart/feature/search/ui/sections/popular_queries.dart';
import 'package:smart/feature/search/ui/sections/search_items.dart';
import 'package:smart/feature/search/ui/widgets/search_appbar.dart';
import 'package:smart/localization/app_localizations.dart';

import '../../../managers/announcement_manager.dart';
import '../../../managers/search_manager.dart';
import '../../../utils/animations.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/conatainers/announcement.dart';
import '../../main/bloc/popularQueries/popular_queries_cubit.dart';
import '../../main/bloc/search/search_announcements_cubit.dart';
import '../bloc/search_announcement_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.showBackButton,
    required this.title,
    this.queryString,
  });

  final bool showBackButton;
  final String title;
  final String? queryString;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  final _controller = ScrollController();
  late SearchManager searchManager;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() async {
      if (_controller.position.atEdge) {
        double maxScroll = _controller.position.maxScrollExtent;
        double currentScroll = _controller.position.pixels;
        if (currentScroll >= maxScroll * 0.8) {
          BlocProvider.of<SearchAnnouncementCubit>(context)
              .searchAnnounces('', false);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    searchManager = RepositoryProvider.of<SearchManager>(context);
    if (widget.queryString != null) {
      setSearch(widget.queryString!, searchManager);
    }

    super.didChangeDependencies();
  }

  void setSearchText(String text) {
    searchController.text = text;
  }

  void setSearch(String query, SearchManager? searchManager) {
    BlocProvider.of<SearchAnnouncementCubit>(context)
        .searchAnnounces(query, true);
    searchManager?.setSearch(false);
    setSearchText(query);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context)!;
    final announcementRepository =
        RepositoryProvider.of<AnnouncementManager>(context);

    searchManager = RepositoryProvider.of<SearchManager>(context);

    searchController.selection = TextSelection(
        baseOffset: searchController.text.length,
        extentOffset: searchController.text.length);

    Widget announcementGridBuilder(BuildContext context, int index) {
      return AnnouncementContainer(
          announcement: announcementRepository.searchAnnouncements[index]);
    }

    SliverGridDelegateWithMaxCrossAxisExtent gridDelegate =
        SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
            childAspectRatio: 160 / 272);

    AppBar searchAppBar = AppBar(
      backgroundColor: AppColors.mainBackground,
      automaticallyImplyLeading: false,
      elevation: 0,
      titleSpacing: 0,
      clipBehavior: Clip.none,
      bottom: !widget.showBackButton ? _buildCategoryAppBarBottom() : null,
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SearchAppBar(
              showBackButton: widget.showBackButton,
              onSubmitted: (String? a) {
                searchManager.setSearch(false);
                searchManager.saveInHistory(a!);
                setState(() {});
                BlocProvider.of<SearchAnnouncementCubit>(context)
                    .searchAnnounces(a, true,
                        parameters: context
                            .read<SearchSelectSubcategoryCubit>()
                            .parameters);
              },
              onChange: (String? a) {
                searchManager.setSearch(true);
                setState(() {});
                BlocProvider.of<SearchItemsCubit>(context).search(a ?? '');
                BlocProvider.of<PopularQueriesCubit>(context)
                    .loadPopularQueries();
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
          HistoryWidget(onDelete: (e) {
            searchManager.deleteQueryByName(e);
            setState(() {});
          }, onSearch: (e) {
            setSearch(e.toString(), searchManager);
          })
        ],
      );
    }

    Widget gridBuild() {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        sliver: SliverGrid(
          gridDelegate: gridDelegate,
          delegate: SliverChildBuilderDelegate(announcementGridBuilder,
              childCount: announcementRepository.searchAnnouncements.length),
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
              BlocBuilder<SearchAnnouncementCubit, SearchAnnouncementState>(
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

  _buildCategoryAppBarBottom() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(96),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  color: AppColors.black,
                ),
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
          Wrap(
            spacing: 6,
            children: [
              FilterChip(
                label: const Text('Prix'),
                onSelected: (value) {},
              ),
              FilterChip(
                label: const Text('Telephones'),
                onSelected: (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
