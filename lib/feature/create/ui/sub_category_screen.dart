import 'package:flutter/material.dart';

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
      body: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 108 / 120,
        children: list
            .map((e) => (name: e.name, imageUrl: e.imageUrl))
            .toList(),
      ),
    );
  }
}
