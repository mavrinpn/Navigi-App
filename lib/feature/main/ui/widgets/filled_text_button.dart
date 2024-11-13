import 'package:flutter/material.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';

class FilledTextButton extends StatelessWidget {
  const FilledTextButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.icon,
  });

  final Function onPressed;
  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.red.withOpacity(0.24),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            height: 24,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTypography.font14lightGray.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.red,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: SizedBox(
                    height: 9,
                    width: 9,
                    child: icon,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
