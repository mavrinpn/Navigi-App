import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';

import '../../../widgets/category/category.dart';
import '../../../widgets/textField/outline_text_field.dart';
import '../../create_announcement/bloc/category/category_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final searchController = TextEditingController();
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 60,
              backgroundColor: AppColors.empty,
              flexibleSpace: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: OutLineTextField(
                  width: MediaQuery.of(context).size.width - 100,
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
                                .map((e) => Padding(
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
                  SizedBox(
                    width: 300,
                    height: 500,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: 100,
                      itemBuilder: (BuildContext context, index) {
                        return Text("$index");
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
