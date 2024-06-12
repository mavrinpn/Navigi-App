import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class AdvertisementContainer extends StatelessWidget {
  final VoidCallback onTap;
  final String imageUrl;
  const AdvertisementContainer({
    super.key,
    required this.onTap,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 100,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: FancyShimmerImage(
            imageUrl: imageUrl,
            boxFit: BoxFit.cover,
            shimmerBaseColor: Colors.grey[300]!,
            shimmerHighlightColor: Colors.grey[100]!,
          ),
        ),
      ),
    );
  }
}
