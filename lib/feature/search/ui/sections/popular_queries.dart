import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/main/bloc/popularQueries/popular_queries_cubit.dart';
import 'package:smart/managers/search_manager.dart';
import 'package:smart/utils/animations.dart';

import '../widgets/popular_query_item.dart';

class PopularQueriesWidget extends StatelessWidget {
  const PopularQueriesWidget({
    super.key,
    required this.onSearch,
  });

  final Function(String e) onSearch;

  @override
  Widget build(BuildContext context) {
    final searchManager = RepositoryProvider.of<SearchManager>(context);

    return SizedBox(
      height: 30,
      child: BlocBuilder<PopularQueriesCubit, PopularQueriesState>(
        builder: (context, state) {
          if (state is PopularQueriesSuccess &&
              searchManager.popularQueries.isNotEmpty) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: searchManager.popularQueries.length,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final e = searchManager.popularQueries.reversed.toList()[index];
                return PopularQueryItem(
                    onTap: () {
                      onSearch(e);
                    },
                    name: e);
              },
            );
          } else if (state is PopularQueriesLoading) {
            return Center(child: AppAnimations.bouncingLine);
          }
          return const Text('Popular Queries failed');
        },
      ),
    );
  }
}
