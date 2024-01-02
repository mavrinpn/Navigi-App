import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/main/bloc/popularQueries/popular_queries_cubit.dart';
import 'package:smart/managers/search_manager.dart';
import 'package:smart/utils/animations.dart';

import '../widgets/popular_query_item.dart';

class PopularQueriesWidget extends StatelessWidget {
  const PopularQueriesWidget({super.key, required this.onSearch});

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
              return ListView(
                scrollDirection: Axis.horizontal,
                children: searchManager.popularQueries.reversed
                    .toList()
                    .map((e) =>
                    PopularQueryItem(
                        onTap: () {
                          onSearch(e);
                        },
                        name: e))
                    .toList(),
              );
            } else if (state is PopularQueriesLoading) {
              return Center(child: AppAnimations.bouncingLine);
            }
            return const Text('проблемс');
          },
        ));
  }}
