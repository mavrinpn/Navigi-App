

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/utils/colors.dart';

class AddImageWidget extends StatelessWidget {
  const AddImageWidget({super.key, required this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: 105,
        height: 98,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.backgroundLightGray,
        ),
        child: Center(
          child: SvgPicture.asset(
            'Assets/icons/add_image.svg',
            width: 32,
          ),
        ),
      ),
    );
  }
}