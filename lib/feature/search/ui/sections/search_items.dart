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
  });

  final Function(KeyWord) onKeywordTap;
  final SearchItemsSuccess state;

  @override
  Widget build(BuildContext context) {
    final String currentLocale = MyApp.getLocale(context) ?? 'fr';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: state.result
          .map((keyword) => Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    onKeywordTap(keyword);
                  },
                  child: Text(
                    currentLocale == 'fr' ? keyword.nameFr : keyword.nameAr,
                    style: AppTypography.font14black,
                  ),
                ),
              ))
          .toList(),
    );
  }
}
