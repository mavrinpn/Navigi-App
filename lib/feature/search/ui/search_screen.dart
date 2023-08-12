import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../managers/announcement_manager.dart';
import '../../../managers/search_manager.dart';
import '../../../utils/animations.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/conatainers/announcement.dart';
import '../../../widgets/textField/elevated_text_field.dart';
import '../../main/bloc/popularQueries/popular_queries_cubit.dart';
import '../../main/bloc/search/search_announcements_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/search_announcement_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  final _controller = ScrollController();

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

  void setSearchText(String text) {
    searchController.text = text;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final searchManager = RepositoryProvider.of<SearchManager>(context);
    final announcementRepository =
        RepositoryProvider.of<AnnouncementManager>(context);

    searchController.selection = TextSelection(
        baseOffset: searchController.text.length,
        extentOffset: searchController.text.length);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.mainBackground,
        ),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.mainBackground,
              elevation: 0,
              flexibleSpace: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {});
                        Navigator.pushNamed(context, '/home_screen');
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.black,
                      ),
                    ),
                    ElevatedTextField(
                      action: TextInputAction.search,
                      onSubmitted: (String? a) {
                        searchManager.setSearch(false);
                        searchManager.saveInHistory(a!);
                        setState(() {});
                        BlocProvider.of<SearchAnnouncementCubit>(context)
                            .searchAnnounces(a, true);
                      },
                      onChange: (String a) {
                        searchManager.setSearch(true);
                        setState(() {});
                        BlocProvider.of<SearchItemsCubit>(context).search(a);
                        BlocProvider.of<PopularQueriesCubit>(context)
                            .loadPopularQueries();
                      },
                      width: searchManager.isSearch
                          ? MediaQuery.of(context).size.width - 160
                          : MediaQuery.of(context).size.width - 70,
                      height: 44,
                      hintText: 'Recherche a Alger',
                      controller: searchController,
                      icon: "Assets/icons/only_search.svg",
                      onTap: () {},
                    ),
                    searchManager.isSearch
                        ? TextButton(
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              searchManager.setSearch(false);
                              setState(() {});
                            },
                            child: const Text('Annulation'),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            body: Stack(children: [
              BlocBuilder<SearchAnnouncementCubit, SearchAnnouncementState>(
                builder: (context, state) {
                  return BlocBuilder<SearchAnnouncementCubit,
                      SearchAnnouncementState>(
                    builder: (context, state) {
                      return CustomScrollView(
                        controller: _controller,
                        physics: const BouncingScrollPhysics(
                            decelerationRate: ScrollDecelerationRate.fast),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 20),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 15,
                                      maxCrossAxisExtent:
                                          MediaQuery.of(context).size.width / 2,
                                      childAspectRatio: 160 / 272),
                              delegate: SliverChildBuilderDelegate(
                                  (context, ind) => AnnouncementContainer(
                                      announcement: announcementRepository
                                          .searchAnnouncements[ind]),
                                  childCount: announcementRepository
                                      .searchAnnouncements.length),
                            ),
                          ),
                          if (state is SearchAnnouncementsLoadingState) ...[
                            SliverToBoxAdapter(
                              child: Center(child: AppAnimations.bouncingLine),
                            )
                          ] else if (state is SearchAnnouncementsFailState ||
                              announcementRepository
                                  .searchAnnouncements.isEmpty) ...[
                            SliverToBoxAdapter(
                                child: Center(
                              child: Text(AppLocalizations.of(context)!.empty),
                            ))
                          ],
                        ],
                      );
                    },
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
                          builder: (context, state) {
                            if (state is SearchItemsSuccess &&
                                searchController.text.isNotEmpty &&
                                state.result.isNotEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.result
                                    .map((e) => Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: InkWell(
                                            onTap: () {
                                              BlocProvider.of<
                                                          SearchAnnouncementCubit>(
                                                      context)
                                                  .searchAnnounces(
                                                      e.name, true);
                                              searchManager.setSearch(false);
                                              setSearchText(e.name);
                                              setState(() {});
                                            },
                                            child: Text(
                                              e.name,
                                              style: AppTypography.font14black,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              );
                            } else if (state is SearchItemsLoading) {
                              return Center(child: AppAnimations.bouncingLine);
                            }
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Recherches populaires',
                                      style: AppTypography.font14black.copyWith(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                    height: 30,
                                    child: BlocBuilder<PopularQueriesCubit,
                                        PopularQueriesState>(
                                      builder: (context, state) {
                                        if (state is PopularQueriesSuccess &&
                                            searchManager
                                                .popularQueries.isNotEmpty) {
                                          return ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: searchManager
                                                .popularQueries.reversed
                                                .toList()
                                                .map((e) => Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 6),
                                                      child: InkWell(
                                                        onTap: () {
                                                          BlocProvider.of<
                                                                      SearchAnnouncementCubit>(
                                                                  context)
                                                              .searchAnnounces(
                                                                  e, true);
                                                          searchManager
                                                              .setSearch(false);
                                                          setSearchText(e);
                                                          searchManager
                                                              .saveInHistory(e);
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        14,
                                                                    vertical:
                                                                        4),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color: AppColors
                                                                  .backgroundLightGray,
                                                            ),
                                                            child: Text(e)),
                                                      ),
                                                    ))
                                                .toList(),
                                          );
                                        } else if (state
                                            is PopularQueriesLoading) {
                                          return Center(
                                              child:
                                                  AppAnimations.bouncingLine);
                                        }
                                        return const Text('проблемс');
                                      },
                                    )),
                                const SizedBox(
                                  height: 32,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Historique des recherches',
                                      style: AppTypography.font14black.copyWith(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Nettoyer',
                                      style: AppTypography.font12lightGray
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                FutureBuilder(
                                    future: searchManager.getHistory(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Column(
                                          children: snapshot.data!
                                              .map((e) => Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 9),
                                                    child: InkWell(
                                                      onTap: () {
                                                        BlocProvider.of<
                                                                    SearchAnnouncementCubit>(
                                                                context)
                                                            .searchAnnounces(
                                                                e.toString(),
                                                                true);
                                                        searchManager
                                                            .setSearch(false);

                                                        setSearchText(
                                                            e.toString());
                                                        setState(() {});
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .backgroundIcon,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            width: 30,
                                                            height: 30,
                                                            child: Center(
                                                              child: SvgPicture
                                                                  .asset(
                                                                'Assets/icons/time.svg',
                                                                width: 20,
                                                                height: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(e
                                                                    .toString()),
                                                                InkWell(
                                                                  onTap: () {
                                                                    searchManager
                                                                        .deleteQueryByName(
                                                                            e);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          'Assets/icons/dagger.svg',
                                                                    width: 25,
                                                                    height: 25,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    })
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
