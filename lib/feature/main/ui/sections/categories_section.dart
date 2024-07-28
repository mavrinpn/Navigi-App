import 'package:flutter/material.dart';
import 'package:smart/feature/main/ui/widgets/categories_scroll_view.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 8, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.categories,
                  textAlign: TextAlign.center,
                  style: AppTypography.font20black,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutesNames.allCategories);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.viewAll,
                    style: AppTypography.font14lightGray.copyWith(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const CategoriesScrollView(),
        ],
      ),
    );
  }
}
