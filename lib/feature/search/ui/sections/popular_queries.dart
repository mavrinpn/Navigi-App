import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/feature/main/bloc/popularQueries/popular_queries_cubit.dart';
import 'package:smart/managers/search_manager.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';

class PopularQueriesWidget extends StatelessWidget {
  const PopularQueriesWidget({
    super.key,
    required this.onSearch,
  });

  final Function(String e) onSearch;

  @override
  Widget build(BuildContext context) {
    final searchManager = RepositoryProvider.of<SearchManager>(context);

    return BlocBuilder<PopularQueriesCubit, PopularQueriesState>(
      builder: (context, state) {
        if (state is PopularQueriesSuccess && searchManager.popularQueries.isNotEmpty) {
          return SizedBox(
            height: searchManager.popularQueries.length > 4 ? 60 : 30,
            child: Wrap(
              clipBehavior: Clip.hardEdge,
              spacing: 6,
              runSpacing: 6,
              children: searchManager.popularQueries.reversed
                  .map(
                    (e) => Container(
                      clipBehavior: Clip.hardEdge,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLightGray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.black12,
                          highlightColor: Colors.black12,
                          onTap: () {
                            onSearch(e);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  e,
                                  style: AppTypography.font12normal.copyWith(
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
          // return ListView.separated(
          //   scrollDirection: Axis.horizontal,
          //   itemCount: searchManager.popularQueries.length,
          //   separatorBuilder: (context, index) => const SizedBox(width: 6),
          //   itemBuilder: (context, index) {
          //     final e = searchManager.popularQueries.reversed.toList()[index];
          //     return PopularQueryItem(
          //         onTap: () {
          //           onSearch(e);
          //         },
          //         name: e);
          //   },
          // );
        } else if (state is PopularQueriesLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: SizedBox(
              height: 60,
              child: Wrap(
                clipBehavior: Clip.hardEdge,
                spacing: 6,
                runSpacing: 6,
                children: [60.0, 80.0, 70.0, 100.0, 70.0, 60.0, 80.0, 70.0, 100.0, 70.0]
                    .map(
                      (e) => Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLightGray,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(width: e),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        }
        return const Text('Popular Queries failed');
      },
    );
  }
}
