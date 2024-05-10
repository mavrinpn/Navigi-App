import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart/models/review.dart';
import 'package:smart/models/user.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/checkBox/star_row_widget.dart';

class ReviewsListWidget extends StatelessWidget {
  const ReviewsListWidget({
    super.key,
    required this.reviews,
    required this.user,
  });

  final List<Review> reviews;
  final UserData user;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 20);
      },
      itemBuilder: (context, index) {
        final review = reviews[index];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: review.creator.imageUrl != ''
                  ? CircleAvatar(
                      foregroundImage: NetworkImage(review.creator.imageUrl),
                    )
                  : const CircleAvatar(),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        review.creator.displayName,
                        style: AppTypography.font12black,
                      ),
                      Text(
                        DateFormat(DateFormat.YEAR_MONTH_DAY)
                            .format(review.createdAt),
                        style: AppTypography.font12gray,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  StarRowWidget(score: review.score, size: 20),
                  const SizedBox(height: 6),
                  Text(
                    review.text,
                    style: AppTypography.font12gray,
                  ),
                ],
              ),
            ),
          ],
        );
      },
      itemCount: reviews.length,
    );
  }
}
