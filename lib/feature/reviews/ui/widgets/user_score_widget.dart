import 'package:flutter/material.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/checkBox/star_row_widget.dart';

class UserScoreWidget extends StatelessWidget {
  const UserScoreWidget({
    super.key,
    required this.score,
    required this.subtitle,
    required this.bigSize,
  });

  final double score;
  final String subtitle;
  final bool bigSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            StarRowWidget(
              score: score.toInt(),
              size: bigSize ? 30 : 20,
            ),
            const SizedBox(width: 8),
            Text(
              score.toStringAsFixed(1),
              style: bigSize ? AppTypography.font20black : AppTypography.font14lightGray,
            ),
          ],
        ),
        if (subtitle.isNotEmpty) const SizedBox(height: 6),
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            style: AppTypography.font14lightGray,
          ),
      ],
    );
  }
}
