import 'package:flutter/material.dart';
import 'package:smart/feature/main/ui/widgets/categories_scroll_view.dart';
import 'package:smart/feature/main/ui/widgets/filled_text_button.dart';
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
            padding: const EdgeInsets.fromLTRB(15, 0, 4, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.categories,
                  textAlign: TextAlign.center,
                  style: AppTypography.font20black,
                ),
                FilledTextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutesNames.allCategories);
                  },
                  title: AppLocalizations.of(context)!.viewAll,
                  icon: Icons.arrow_forward_ios_rounded,
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
