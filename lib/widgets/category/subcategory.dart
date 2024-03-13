import 'package:flutter/material.dart';
import 'package:smart/main.dart';
import 'package:smart/models/models.dart';
import 'package:smart/utils/fonts.dart';

class SubCategoryWidget extends StatelessWidget {
  const SubCategoryWidget({
    super.key,
    required this.subcategory,
    required this.onTap,
  });

  final Subcategory subcategory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                subcategory.localizedName(MyApp.getLocale(context) ?? 'fr'),
                overflow: TextOverflow.ellipsis,
                style: AppTypography.font16black,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
