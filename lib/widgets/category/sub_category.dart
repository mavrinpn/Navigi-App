import 'package:flutter/material.dart';
import 'package:smart/generated/assets.dart';
import 'package:smart/utils/fonts.dart';

class SubCategoryWidget extends StatelessWidget {
  const SubCategoryWidget(
      {super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      height: 130,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Immobilier',
            style: AppTypography.font16black,
          ),
          InkWell(
            onTap: () {},
            child: Icon(
              Icons.arrow_forward_ios,
            ),
          )
        ],
      ),
    );
  }
}
