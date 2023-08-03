// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/main/bloc/search/search_announcements_cubit.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';

import '../../../managers/announcement_manager.dart';
import '../../../managers/search_manager.dart';
import '../../../utils/animations.dart';
import '../../../widgets/category/category.dart';
import '../../../widgets/conatainers/announcement.dart';
import '../../../widgets/textField/elevated_text_field.dart';
import '../../create_announcement/bloc/category/category_cubit.dart';
import '../bloc/announcements/announcement_cubit.dart';
import '../bloc/popularQueries/popular_queries_cubit.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    _controller.addListener(() async {
      if (_controller.position.atEdge) {
        double maxScroll = _controller.position.maxScrollExtent;
        double currentScroll = _controller.position.pixels;
        if (currentScroll >= maxScroll * 0.8) {
          print(1);
          BlocProvider.of<AnnouncementsCubit>(context).loadAnnounces();
        }
      }
    });
  }

  bool isSearch = false;

  void setSearch(bool f) {
    isSearch = f;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final announcementRepository =
        RepositoryProvider.of<AnnouncementManager>(context);
    final searchManager = RepositoryProvider.of<SearchManager>(context);

    return InkWell(
      focusColor: AppColors.empty,
      hoverColor: AppColors.empty,
      highlightColor: AppColors.empty,
      splashColor: AppColors.empty,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.mainBackground,
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  ElevatedTextField(
                    onTap: () {
                      BlocProvider.of<PopularQueriesCubit>(context)
                          .loadPopularQueries();
                      setSearch(true);
                      setState(() {});
                    },
                    onChange: (String a) {
                      BlocProvider.of<SearchAnnouncementsCubit>(context)
                          .search(a);
                    },
                    width: isSearch
                        ? MediaQuery.of(context).size.width - 120
                        : MediaQuery.of(context).size.width - 30,
                    height: 44,
                    hintText: 'Recherche a Alger',
                    controller: searchController,
                    icon: "Assets/icons/only_search.svg",
                  ),
                  isSearch
                      ? TextButton(
                          onPressed: () {
                            searchController.text = '';
                            setSearch(false);
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
            BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
              builder: (context, state) {
                return CustomScrollView(
                  controller: _controller,
                  physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppLocalizations.of(context)!.categories,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.font20black),
                                Text('Regarder tout',
                                    style: AppTypography.font14lightGray
                                        .copyWith(fontSize: 12)),
                              ],
                            ),
                          ),
                          BlocBuilder<CategoryCubit, CategoryState>(
                            builder: (context, state) {
                              if (state is CategorySuccessState) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 160,
                                  child: ListView(
                                    physics: const BouncingScrollPhysics(
                                        decelerationRate:
                                            ScrollDecelerationRate.fast),
                                    scrollDirection: Axis.horizontal,
                                    children: state.categories
                                        .map((e) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 0),
                                              child: CategoryWidget(
                                                category: e,
                                                isActive: false,
                                                width: 108,
                                                height: 160,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                );
                              } else if (state is CategoryFailState) {
                                return const Center(
                                  child: Text('Проблемс'),
                                );
                              } else {
                                return Center(
                                  child: AppAnimations.bouncingLine,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 11,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppLocalizations.of(context)!.recommendations,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.font20black),
                                Text('Regarder tout',
                                    style: AppTypography.font14lightGray
                                        .copyWith(fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 15,
                            maxCrossAxisExtent:
                                MediaQuery.of(context).size.width / 2,
                            childAspectRatio: 160 / 272),
                        delegate: SliverChildBuilderDelegate(
                            (context, ind) => AnnouncementContainer(
                                announcement:
                                    announcementRepository.announcements[ind]),
                            childCount:
                                announcementRepository.announcements.length),
                      ),
                    ),
                    if (state is AnnouncementsLoadingState) ...[
                      SliverToBoxAdapter(
                        child: Container(
                          child: Center(child: AppAnimations.bouncingLine),
                        ),
                      )
                    ],
                  ],
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
                    height: isSearch ? height : 0,
                    color: Colors.white,
                    padding: const EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: BlocBuilder<SearchAnnouncementsCubit,
                          SearchAnnouncementsState>(
                        builder: (context, state) {
                          if (state is SearchSuccess &&
                              searchController.text.isNotEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: state.result
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text(
                                          e.name,
                                          style: AppTypography.font14black,
                                        ),
                                      ))
                                  .toList(),
                            );
                          } else if (state is SearchWait ||
                              searchController.text.isEmpty) {
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
                                        if(state is PopularQueriesSuccess){
                                          return ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: searchManager.popularQueries
                                                .map((e) => Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 6),
                                              child: Container(
                                                  alignment:
                                                  Alignment.center,
                                                  padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 14,
                                                      vertical: 4),
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(20),
                                                    color: AppColors
                                                        .backgroundLightGray,
                                                  ),
                                                  child: Text(e)),
                                            ))
                                                .toList(),
                                          );
                                        } else if(state is PopularQueriesLoading){
                                          return Center(child: AppAnimations.bouncingLine);
                                        }
                                        return Text('проблемс');
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
                                      'Recherches populaires',
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
                                Column(
                                  children: List.generate(10, (index) => index)
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 9),
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .backgroundIcon,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  width: 30,
                                                  height: 30,
                                                  child: Center(
                                                    child: SvgPicture.asset(
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
                                                      Text(e.toString()),
                                                      SvgPicture.asset(
                                                          'Assets/icons/dagger.svg')
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                )
                              ],
                            );
                          } else if (state is SearchLoading) {
                            return Center(child: AppAnimations.bouncingLine);
                          }

                          return const Text('asdf');
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
    );
  }
}
