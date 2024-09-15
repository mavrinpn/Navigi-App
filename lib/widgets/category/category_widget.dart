import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart/main.dart';
import 'package:smart/models/category.dart';
import 'package:smart/utils/fonts.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({
    super.key,
    required this.category,
    required this.onTap,
  });

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.category.imageUrl!,
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.category.getLocalizedName(MyApp.getLocale(context) ?? 'fr'),
            style: AppTypography.font24black.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
