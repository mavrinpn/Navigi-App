import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create/bloc/sub_category/sub_category_cubit.dart';
import 'package:smart/generated/assets.dart';
import 'package:smart/models/category.dart';
import 'package:smart/utils/fonts.dart';

class CategoryWidget extends StatelessWidget {
  CategoryWidget({super.key, required Category category})
      : name = category.name,
        imageUrl = category.imageUrl,
        id = category.id;

  final String name;
  final String imageUrl;
  final String id;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<SubCategoryCubit>(context).loadSubCategories(id);
        Navigator.pushNamed(context, '/create_sub_category_screen');
      },
      child: SizedBox(
        width: 108,
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 108,
              height: 100,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: NetworkImage(imageUrl), fit: BoxFit.cover)),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              name,
              style: AppTypography.font24black.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
