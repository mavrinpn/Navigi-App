// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/favorites/bloc/favourites_cubit.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/images/announcement_image.dart';

import '../../feature/announcement/bloc/announcement/announcement_cubit.dart';
import '../../utils/colors.dart';

class AnnouncementContainer extends StatefulWidget {
  const AnnouncementContainer({
    super.key,
    required this.announcement,
    this.width,
    this.height,
  });

  final double? width, height;
  final Announcement announcement;

  @override
  State<AnnouncementContainer> createState() => _AnnouncementContainerState();
}

class _AnnouncementContainerState extends State<AnnouncementContainer> {
  bool liked = false;

  @override
  void initState() {
    liked = BlocProvider.of<FavouritesCubit>(context)
        .isLiked(widget.announcement.id);
    super.initState();
  }

  void onLikeTapped() {
    BlocProvider.of<FavouritesCubit>(context)
        .likeUnlike(widget.announcement.id);
    setState(() {
      liked = !liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final double imageWidth = widget.width ?? width / 2 - 25;
    final double imageHeight = widget.height ?? (width / 2 - 25) * 1.032;

    return GestureDetector(
        onTap: () async {
          BlocProvider.of<AnnouncementCubit>(context)
              .loadAnnouncementById(widget.announcement.id);
          Navigator.pushNamed(context, AppRoutesNames.announcement);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: imageWidth,
              height: imageHeight,
              child: AnnouncementImage(
                announcement: widget.announcement,
                width: imageWidth,
                height: imageHeight,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: imageWidth,
              child: Text(
                widget.announcement.title,
                style: AppTypography.font12dark,
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            BlocListener<FavouritesCubit, FavouritesState>(
              listener: (context, state) {
                if (state is LikeSuccessState &&
                    state.changedPostId == widget.announcement.id) {
                  setState(() {
                    liked = state.value;
                  });
                }
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.announcement.stringPrice,
                      style: AppTypography.font16boldRed,
                      textDirection: TextDirection.ltr,
                    ),
                    GestureDetector(
                        onTap: onLikeTapped,
                        child: SvgPicture.asset('Assets/icons/follow.svg',
                            width: 24,
                            height: 24,
                            color: liked ? AppColors.red : AppColors.whiteGray))
                  ]),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  widget.announcement.creatorData.name,
                  style: widget.announcement.creatorData.verified
                      ? AppTypography.font12lightGray.copyWith(
                          color: const Color(0xFF0F7EE4),
                          fontWeight: FontWeight.w400)
                      : AppTypography.font12lightGray
                          .copyWith(fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.announcement.creatorData.verified) ...[
                  const SizedBox(
                    width: 5,
                  ),
                  SvgPicture.asset(
                    'Assets/icons/verified-user.svg',
                    width: 12,
                  )
                ]
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset('Assets/icons/point.svg'),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: RichText(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: [
                        TextSpan(
                            text: ' ${widget.announcement.placeData.name}',
                            style: AppTypography.font14black),
                      ])),
                )
              ],
            ),
          ],
        ));
  }
}
