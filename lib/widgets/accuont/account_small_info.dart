import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/announcement/bloc/creator_cubit/creator_cubit.dart';
import 'package:smart/feature/reviews/ui/widgets/user_score_widget.dart';
import 'package:smart/generated/assets.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/images/network_image.dart';

import '../../localization/app_localizations.dart';
import '../../models/announcement.dart';

class AccountSmallInfo extends StatefulWidget {
  const AccountSmallInfo({
    super.key,
    required this.creatorData,
    required this.clickable,
  });

  final CreatorData creatorData;
  final bool clickable;

  @override
  State<AccountSmallInfo> createState() => _AccountSmallInfoState();
}

class _AccountSmallInfoState extends State<AccountSmallInfo> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void onClick() {
      BlocProvider.of<CreatorCubit>(context).setUser(
        creatorId: widget.creatorData.uid,
        userData: widget.creatorData.toUserData(),
      );
      // BlocProvider.of<CreatorCubit>(context).setUserId(widget.creatorData.uid);
      // BlocProvider.of<CreatorCubit>(context).setUserData(widget.creatorData.toUserData());
      Navigator.pushNamed(context, AppRoutesNames.announcementCreator);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: InkWell(
        onTap: widget.clickable ? onClick : null,
        child: Container(
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.seller,
                        style: AppTypography.font14lightGray.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.creatorData.displayName,
                              style: AppTypography.font18black,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                            child: Row(
                              children: [
                                UserScoreWidget(
                                  score: widget.creatorData.rating,
                                  subtitle: '',
                                  bigSize: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(Assets.iconsPoint),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(text: ' ${widget.creatorData.place.name}', style: AppTypography.font14black),
                            TextSpan(text: '  ${widget.creatorData.distance}', style: AppTypography.font14lightGray),
                          ]))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
