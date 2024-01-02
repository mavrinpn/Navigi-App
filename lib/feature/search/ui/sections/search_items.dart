import 'package:flutter/material.dart';
import 'package:smart/feature/main/bloc/search/search_announcements_cubit.dart';
import 'package:smart/utils/utils.dart';

class SearchItemsWidget extends StatelessWidget {
  const SearchItemsWidget({super.key, required this.state, required this.setSearch});

  final Function(String) setSearch;
  final SearchItemsSuccess state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: state.result
          .map((e) => Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    setSearch(e.name);
                  },
                  child: Text(
                    e.name,
                    style: AppTypography.font14black,
                  ),
                ),
              ))
          .toList(),
    );
  }
}
