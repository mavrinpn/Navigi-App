import 'package:flutter/material.dart';
import 'package:smart/feature/search/ui/bottom_sheets/subcategory_filter_bottom_sheet.dart';

class AllCategoriesPage extends StatelessWidget {
  const AllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SubcategoriesWidget(
      isBottomSheet: false,
      needOpenNewScreen: true,
    );
  }
}
