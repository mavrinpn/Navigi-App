import 'package:flutter/material.dart';
import 'package:smart/widgets/category/sub_category.dart';

import '../../../models/subCategory.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';

List<SubCategory> list = [
  SubCategory(name: 'a', categoryId: ''),
  SubCategory(name: 'a', categoryId: ''),
  SubCategory(name: 'a', categoryId: ''),
  SubCategory(name: 'a', categoryId: ''),
  SubCategory(name: 'a', categoryId: ''),
  SubCategory(name: 'a', categoryId: ''),
  SubCategory(name: 'a', categoryId: ''),
  SubCategory(name: 'a', categoryId: ''),
];

class SubCategoryScreen extends StatelessWidget {
  const SubCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        backgroundColor: AppColors.empty,
        elevation: 0,
        title: Text(
          'Ajouter une annonce',
          style: AppTypography.font20black,
        ),
      ),
      body: ListView(
        children: list
            .map((e) => SubCategoryWidget(name: e.name))
            .toList(),
      ),
    );
  }
}
