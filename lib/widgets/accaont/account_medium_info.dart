import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:smart/generated/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';

import '../../models/announcement.dart';

class AccountMediumInfo extends StatefulWidget {
  const AccountMediumInfo({super.key, required this.creatorData});

  final CreatorData creatorData;

  @override
  State<AccountMediumInfo> createState() => _AccountMediumInfoState();
}

class _AccountMediumInfoState extends State<AccountMediumInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(children: [
                const Image(
                  image: AssetImage(Assets.assetsRandomPeople),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                Container(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset(
                      'Assets/icons/isNotConfirmed.svg',
                      width: 24,
                      height: 24,
                    )),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Le Vendeur',
                    style: AppTypography.font14lightGray.copyWith(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 70,
                        child: Text(
                          widget.creatorData.name,
                          style: AppTypography.font20black,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 4),
                        child: RatingStars(
                          value: widget.creatorData.score,
                          starBuilder: (index, color) => Icon(
                            Icons.star,
                            color: color,
                            size: 20,
                          ),
                          starCount: 5,
                          starSize: 20,
                          valueLabelColor: const Color(0xff9b9b9b),
                          maxValue: 5,
                          starSpacing: 2,
                          valueLabelPadding: EdgeInsets.zero,
                          valueLabelMargin: EdgeInsets.zero,
                          maxValueVisibility: true,
                          valueLabelVisibility: false,
                          starOffColor: AppColors.disable,
                          starColor: AppColors.starsActive,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${widget.creatorData.score}',
                        style: AppTypography.font14black.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'data',
                    style: AppTypography.font12lightGray
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
