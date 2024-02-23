import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/category.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/images/network_image.dart';

import '../../feature/create_announcement/bloc/subcategory/subcategory_cubit.dart';
import '../../utils/colors.dart';

class CategoryWidget extends StatefulWidget {
  CategoryWidget(
      {super.key,
      required Category category,
      required this.height,
      required this.width, required this.onTap})
      : name = category.name ?? '',
        url = category.imageUrl!;

  final String name;
  final String url;
  final double width;
  final double height;

  final VoidCallback onTap;

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 15,
            ),
            CustomNetworkImage(width: 108, height: 100, url: widget.url),
            const SizedBox(
              height: 12,
            ),
            Text(
              widget.name,
              style: AppTypography.font24black.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
