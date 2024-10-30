import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
        child: AspectRatio(
          aspectRatio: 3.4,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: CachedNetworkImage(
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              placeholderFadeInDuration: Duration.zero,
              imageUrl: imageUrl,
              errorWidget: (context, url, _) => Container(
                color: Colors.grey.withAlpha(80),
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey,
                  size: 64,
                ),
              ),
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.grey[300],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
