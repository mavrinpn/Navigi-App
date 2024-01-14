import 'package:flutter/material.dart';
import 'package:smart/utils/colors.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.callback});
  final VoidCallback? callback;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: AppColors.empty,
      hoverColor: AppColors.empty,
      highlightColor: AppColors.empty,
      splashColor: AppColors.empty,
      onTap: () {
        if (callback != null) callback!();
        Navigator.pop(context);
      },
      child: const SizedBox(
        width: 35,
        height: 48,
        child: Icon(
          Icons.arrow_back,
          color: AppColors.black,
        ),
      ),
    )
    ;
  }
}
