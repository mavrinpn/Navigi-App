import 'package:flutter/material.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/checkBox/star_row_widget.dart';

class UserScoreWidget extends StatelessWidget {
  const UserScoreWidget({
    super.key,
    required this.score,
    required this.subtitle,
  });

  final double score;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            StarRowWidget(
              score: score.toInt(),
              size: 30,
            ),
            const SizedBox(width: 8),
            Text(
              '$score',
              style: AppTypography.font20black,
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: AppTypography.font14lightGray,
        ),
      ],
    );
  }
}
