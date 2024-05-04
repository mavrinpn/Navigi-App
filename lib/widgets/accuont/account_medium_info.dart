import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/images/network_image.dart';

import '../../localization/app_localizations.dart';
import '../../models/user.dart';

class AccountMediumInfo extends StatefulWidget {
  const AccountMediumInfo({super.key, required this.user});

  final UserData user;

  @override
  State<AccountMediumInfo> createState() => _AccountMediumInfoState();
}

class _AccountMediumInfoState extends State<AccountMediumInfo> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
                CustomNetworkImage(
                  width: 100,
                  height: 100,
                  url: widget.user.imageUrl,
                  borderRadius: 50,
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 162,
                    child: Material(
                      color: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutesNames.reviews,
                            arguments: widget.user,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Wrap(
                            children: [
                              Text(
                                widget.user.displayName,
                                style: AppTypography.font20black,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(width: 10),
                              widget.user.rating != -1
                                  ? Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                          child: RatingStars(
                                            value: widget.user.rating,
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
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 3),
                                            Text(
                                              '${widget.user.rating}',
                                              style: AppTypography.font14black.copyWith(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${localizations.onTheServiceOf} ${widget.user.atService}',
                    style: AppTypography.font12lightGray.copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
