import 'package:flutter/material.dart';
import 'package:smart/models/category.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/category/category.dart';
List<Category> list = [Category(imageUrl: 'asdfasf', name: 'a'),Category(imageUrl: 'asdfasf', name: 'a'),Category(imageUrl: 'asdfasf', name: 'a'),Category(imageUrl: 'asdfasf', name: 'a'),Category(imageUrl: 'asdfasf', name: 'a'),Category(imageUrl: 'asdfasf', name: 'a'),Category(imageUrl: 'asdfasf', name: 'a'),Category(imageUrl: 'asdfasf', name: 'a'),Category(imageUrl: 'asdfasf', name: 'a'),];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        backgroundColor: AppColors.empty,
        elevation: 0,
        title: Text('Ajouter une annonce',style: AppTypography.font20black,),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: list.map((e) => CategoryWidget(name: e.name, imageUrl: e.imageUrl)).toList(),
      ),
    );
  }
}
