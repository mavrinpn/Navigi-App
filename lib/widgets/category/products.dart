import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/utils/fonts.dart';

import '../../feature/create/data/creting_announcement_manager.dart';
import '../../utils/colors.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget(
      {super.key, required this.name, required this.onTap});

  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundLightGray,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Text(
          name,
          style: AppTypography.font14black.copyWith(fontSize: 16),
        ),
      ),
    );
  }
}
