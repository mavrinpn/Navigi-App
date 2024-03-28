import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/favorites/bloc/favourites_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/images/announcement_image.dart';
import 'package:smart/widgets/snackBar/snack_bar.dart';

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
    final localizations = AppLocalizations.of(context)!;
    BlocProvider.of<FavouritesCubit>(context)
        .likeUnlike(widget.announcement.id);
    setState(() {
      CustomSnackBar.showSnackBar(
        context,
        liked
            ? localizations.adRemovedFromFavorites
            : localizations.adAddedToFavorites,
      );
      liked = !liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final double imageWidth = widget.width ?? width / 2 - 25;
    final double imageHeight = widget.height ?? (width / 2 - 25) * 1.032;

    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutesNames.announcement,
            arguments: widget.announcement.id,
          );
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
            const SizedBox(height: 10),
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
            const SizedBox(height: 5),
            BlocListener<FavouritesCubit, FavouritesState>(
              listener: (context, state) {
                if (state is LikeSuccessState &&
                    state.changedPostId == widget.announcement.id) {
                  setState(() {
                    liked = state.value;
                  });
                }
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.announcement.stringPrice,
                          style: AppTypography.font16boldRed,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: -12,
                    right: -10,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: onLikeTapped,
                      icon: SvgPicture.asset(
                        'Assets/icons/follow.svg',
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          liked ? AppColors.red : AppColors.whiteGray,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
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
                  const SizedBox(width: 5),
                  SvgPicture.asset(
                    'Assets/icons/verified-user.svg',
                    width: 12,
                  )
                ]
              ],
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset('Assets/icons/point.svg'),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    widget.announcement.area.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.font14black,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}