import 'package:flutter/material.dart';
import 'package:smart/utils/fonts.dart';

class SubCategoryWidget extends StatelessWidget {
  const SubCategoryWidget(
      {super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/create_search_products_screen');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Immobilier',
              style: AppTypography.font16black,
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
