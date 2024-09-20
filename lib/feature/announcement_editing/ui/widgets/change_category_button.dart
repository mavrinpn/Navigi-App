import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';

class ChangeCategoryButton extends StatelessWidget {
  const ChangeCategoryButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'Assets/icons/categories.svg',
              width: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                localizations.category,
                style: AppTypography.font16black.copyWith(fontSize: 18),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
              color: AppColors.lightGray,
            ),
          ],
        ),
      ),
    );
  }
}
