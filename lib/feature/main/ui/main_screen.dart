import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/main/bloc/announcement_manager.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';

import '../../../widgets/category/category.dart';
import '../../../widgets/conatainers/anouncment.dart';
import '../../../widgets/textField/outline_text_field.dart';
import '../../create_announcement/bloc/category/category_cubit.dart';
import '../bloc/announcement_cubit.dart';

var list = [1, 2, 3, 4, 5, 6, 7];

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

    // Setup the listener.
    _controller.addListener(() async {
      if (_controller.position.atEdge) {
        double maxScroll = _controller.position.maxScrollExtent;
        double currentScroll = _controller.position.pixels;
        if (currentScroll == maxScroll) {
          BlocProvider.of<AnnouncementCubit>(context).loadAnnounces();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<AnnouncementManager>(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            SliverAppBar(
              expandedHeight: 60,
              backgroundColor: AppColors.empty,
              flexibleSpace: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: OutLineTextField(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 100,
                  height: 52,
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
                                decelerationRate: ScrollDecelerationRate.fast),
                            scrollDirection: Axis.horizontal,
                            children: state.categories
                                .map((e) =>
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: CategoryWidget(
                                    category: e,
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
                        return const Center(
                          child: CircularProgressIndicator(),
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
                        Text('Catégories',
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
            BlocBuilder<AnnouncementCubit, AnnouncementState>(
              builder: (context, state) {
                if (state is AnnouncementsSuccessState) {
                  return SliverList(
                      delegate: SliverChildListDelegate(repository.announcements
                          .map((e) =>
                          AnnouncementContainer(
                            announcement: e,
                          ))
                          .toList()));
                }
                else {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
