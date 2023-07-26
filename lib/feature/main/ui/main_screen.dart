// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';

import '../../../managers/announcement_manager.dart';
import '../../../utils/animations.dart';
import '../../../widgets/category/category.dart';
import '../../../widgets/conatainers/announcement.dart';
import '../../../widgets/textField/elevated_text_field.dart';
import '../../create_announcement/bloc/category/category_cubit.dart';
import '../bloc/announcement_cubit.dart';

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

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<AnnouncementManager>(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
          builder: (context, state) {
            print(repository.announcements.length);

            return CustomScrollView(
              controller: _controller,
              physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast),
              slivers: [
                SliverAppBar(
                  backgroundColor: AppColors.mainBackground,
                  elevation: 0,
                  pinned: true,
                  collapsedHeight: 74,
                  expandedHeight: 74,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                    child: ElevatedTextField(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 44,
                      hintText: 'Recherche a Alger',
                      controller: searchController,
                      icon: "Assets/icons/only_search.svg",
                    ),
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
                            Text('Catégories',
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 0),
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
                            Text('Recommandations',
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
                            announcement: repository.announcements[ind]),
                        childCount: repository.announcements.length),
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
      ),
    );
  }
}
