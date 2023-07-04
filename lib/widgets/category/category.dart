import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/models/category.dart';
import 'package:smart/utils/fonts.dart';

import '../../feature/create_announcement/bloc/sub_category/subcategory_cubit.dart';
import '../../utils/colors.dart';

class CategoryWidget extends StatefulWidget {
  CategoryWidget({super.key, required Category category, this.isActive = true})
      : name = category.name ?? '',
        id = category.id ?? '',
        _image = NetworkImage(category.imageUrl!);

  final bool isActive;
  final String name;
  final String id;
  final NetworkImage _image;

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    widget._image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
            (info, call) {
              loading = false;
          setState(() {});
        },
      ),
    );

    return InkWell(
      focusColor: AppColors.empty,
      hoverColor: AppColors.empty,
      highlightColor: AppColors.empty,
      splashColor: AppColors.empty,
      onTap: () {
        if (widget.isActive) {
          BlocProvider.of<SubcategoryCubit>(context).loadSubCategories(widget.id);
          Navigator.pushNamed(context, '/create_sub_category_screen');
        }

      },
      child: SizedBox(
        width: 108,
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            loading ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 108,
                height: 100,
                
                decoration: BoxDecoration(
                  color: Colors.grey[300]!,
                  borderRadius: BorderRadius.circular(14)
                ),
              ),
            ) : Container(
              width: 108,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image:widget._image, fit: BoxFit.cover)),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              widget.name,
              style: AppTypography.font24black.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
