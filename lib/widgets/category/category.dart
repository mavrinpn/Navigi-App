import 'package:flutter/material.dart';
import 'package:smart/main.dart';
import 'package:smart/models/category.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/images/network_image.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({
    super.key,
    required this.category,
    required this.height,
    required this.width,
    required this.onTap,
  });

  final double width;
  final double height;
  final Category category;

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
            CustomNetworkImage(
                width: 108, height: 100, url: widget.category.imageUrl!),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.category
                  .getLocalizedName(MyApp.getLocale(context) ?? 'fr'),
              style: AppTypography.font24black.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
