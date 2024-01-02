// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/search/ui/widgets/filters_bottom_sheet.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../../../managers/announcement_manager.dart';
import '../../../utils/animations.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/category/category.dart';
import '../../../widgets/conatainers/advertisement_containers.dart';
import '../../../widgets/conatainers/announcement.dart';
import '../../../widgets/textField/elevated_text_field.dart';
import '../../create_announcement/bloc/category/category_cubit.dart';
import '../../search/bloc/search_announcement_cubit.dart';
import '../bloc/announcements/announcement_cubit.dart';
import '../bloc/popularQueries/popular_queries_cubit.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart/feature/search/ui/search_screen.dart';

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
          BlocProvider.of<AnnouncementsCubit>(context).loadAnnounces(false);
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
    final announcementRepository =
        RepositoryProvider.of<AnnouncementManager>(context);

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
              child: Row( crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedTextField(
                    readOnly: true,
                    onTap: () {
                      BlocProvider.of<PopularQueriesCubit>(context)
                          .loadPopularQueries();
                      BlocProvider.of<SearchAnnouncementCubit>(context)
                          .searchAnnounces('', true);
                      Navigator.pushNamed(context, AppRoutesNames.search);
                    },
                    width: isSearch
                        ? MediaQuery.of(context).size.width - 120
                        : MediaQuery.of(context).size.width - 91,
                    height: 44,
                    hintText: 'Recherche a Alger',
                    controller: TextEditingController(),
                    icon: "Assets/icons/only_search.svg",
                  ),
                  const SizedBox(width: 17),
                  CustomIconButtonSearch(
                      assetName: 'Assets/icons/sliders.svg',
                      callback: () {
                        showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return const FiltersBottomSheet(needOpenNewScreen: true,);
                          },
                        );
                      },
                      height: 44,
                      width: 44),
                  isSearch
                      ? TextButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
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
          body: BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
            builder: (context, state) {
              return RefreshIndicator(
                color: AppColors.red,
                onRefresh: () async {
                  BlocProvider.of<AnnouncementsCubit>(context)
                      .loadAnnounces(true);
                },
                child: CustomScrollView(
                  controller: _controller,
                  physics: const AlwaysScrollableScrollPhysics(),
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
                                Text(AppLocalizations.of(context)!.viewAll, // TODO CHECK there are can be not this key
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
                    SliverToBoxAdapter(child:AdvertisementContainer(onTap: (){},imageUrl: 'https://avatars.mds.yandex.net/i?id=6deffd61630391bd9df44801831eb1ef_sr-5241446-images-thumbs&n=13',),),
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
                                Text(
                                    AppLocalizations.of(context)!.recommendations,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.font20black),
                                Text(AppLocalizations.of(context)!.viewAll,
                                    style: AppTypography.font14lightGray
                                        .copyWith(fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
