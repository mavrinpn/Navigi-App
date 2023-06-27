import 'package:flutter/material.dart';
import 'package:smart/generated/assets.dart';
import 'package:smart/utils/fonts.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key, required this.name, required this.imageUrl});

  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108,
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 108,
            height: 100,
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(Assets.assetsGoogle),fit: BoxFit.cover)),
          ),
          const SizedBox(height: 12,),
          Text('Immobilier', style: AppTypography.font24black.copyWith(fontSize: 12),),
        ],
      ),
    );
  }
}
