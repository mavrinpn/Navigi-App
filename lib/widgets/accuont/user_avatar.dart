import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/utils/colors.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.size,
    required this.imageUrl,
    required this.userName,
  });

  final double size;
  final String imageUrl;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      foregroundColor: AppColors.red,
      backgroundColor: AppColors.red,
      foregroundImage: CachedNetworkImageProvider(imageUrl),
      child: imageUrl.isNotEmpty
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size / 2),
                ),
                height: double.infinity,
                width: double.infinity,
              ),
            )
          : Text(
              userName.characters.firstOrNull?.toUpperCase() ?? 'N',
              style: TextStyle(
                fontSize: size / 2.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }
}
