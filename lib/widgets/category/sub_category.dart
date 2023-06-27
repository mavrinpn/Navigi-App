import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create/bloc/item_search/item_search_cubit.dart';
import 'package:smart/utils/fonts.dart';

class SubCategoryWidget extends StatelessWidget {
  const SubCategoryWidget(
      {super.key, required this.name, required this.id});

  final String name;
  final String id;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<ItemSearchCubit>(context).setSubcategory(id);
        Navigator.pushNamed(context, '/create_search_products_screen');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
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
