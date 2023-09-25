import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/announcement/bloc/creator_cubit/creator_cubit.dart';
import 'package:smart/generated/assets.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/images/network_image.dart';

import '../../models/announcement.dart';


import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSmallInfo extends StatefulWidget {
  AccountSmallInfo({super.key, required this.creatorData, required this.isclick});

  final CreatorData creatorData;
  final bool isclick;
  final notclick = null;

  @override
  State<AccountSmallInfo> createState() => _AccountSmallInfoState();
}

class _AccountSmallInfoState extends State<AccountSmallInfo> {
  @override
  Widget build(BuildContext context) {

    final localizations = AppLocalizations.of(context)!;

    void onClick(){
      BlocProvider.of<CreatorCubit>(context).setUserId(widget.creatorData.uid);
      BlocProvider.of<CreatorCubit>(context).setUserData(widget.creatorData.toUserData());
      Navigator.pushNamed(context, '/creator_screen');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: InkWell(
        onTap: widget.isclick? onClick : widget.notclick,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 18,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.creatorData.imageUrl.isEmpty
                    ? Container(
                        width: 64,
                        height: 64,
                        decoration: const ShapeDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.assetsRandomPeople),
                            fit: BoxFit.fill,
                          ),
                          shape: OvalBorder(),
                        ),
                      )
                    : CustomNetworkImage(
                        width: 64,
                        height: 64,
                        url: widget.creatorData.imageUrl,
                        borderRadius: 32,
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.seller,
                        style:
                            AppTypography.font14lightGray.copyWith(fontSize: 12),
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
                              style: AppTypography.font18black,
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
                            style: AppTypography.font14black,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(Assets.iconsPoint),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: ' ${widget.creatorData.place.name}',
                                style: AppTypography.font14black),
                            TextSpan(
                                text: '  ${widget.creatorData.distance}',
                                style: AppTypography.font14lightGray),
                          ]))
                        ],
                      )
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
