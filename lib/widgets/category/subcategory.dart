import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/subcategory/subcategory_cubit.dart';
import 'package:smart/models/models.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../../feature/create_announcement/bloc/item_search/item_search_cubit.dart';

class SubCategoryWidget extends StatelessWidget {
  const SubCategoryWidget({super.key, required this.subcategory, required this.onTap});

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
            Text(
              subcategory.name,
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
