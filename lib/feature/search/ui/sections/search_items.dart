import 'package:flutter/material.dart';
import 'package:smart/feature/main/bloc/search/search_announcements_cubit.dart';
import 'package:smart/main.dart';
import 'package:smart/models/key_word.dart';
import 'package:smart/utils/utils.dart';

class SearchItemsWidget extends StatelessWidget {
  const SearchItemsWidget({
    super.key,
    required this.state,
    required this.onKeywordTap,
    required this.onCurrentQueryTap,
  });

  final Function(KeyWord) onKeywordTap;
  final Function(String) onCurrentQueryTap;
  final SearchItemsSuccess state;

  @override
  Widget build(BuildContext context) {
    final String currentLocale = MyApp.getLocale(context) ?? 'fr';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextButton(
        onPressed: () {
          onCurrentQueryTap(state.currentQuery);
        },
        child: SizedBox(
          width: double.infinity,
          child: Text(
            state.currentQuery,
            textAlign: TextAlign.start,
            style: AppTypography.font14black,
          ),
        ),
      ),
      ...state.result
          .map(
            (keyword) => TextButton(
              onPressed: () {
                onKeywordTap(keyword);
              },
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  currentLocale == 'fr' ? keyword.nameFr : keyword.nameAr,
                  textAlign: TextAlign.start,
                  style: AppTypography.font14black,
                ),
              ),
            ),
          )
          .toList(),
    ]);
  }
}
