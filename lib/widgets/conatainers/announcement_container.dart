import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/feature/favorites/bloc/favourites_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/snackBar/snack_bar.dart';

class AnnouncementContainer extends StatefulWidget {
  const AnnouncementContainer({
    super.key,
    required this.announcement,
  });

  final Announcement announcement;

  @override
  State<AnnouncementContainer> createState() => _AnnouncementContainerState();
}

class _AnnouncementContainerState extends State<AnnouncementContainer> {
  bool liked = false;

  @override
  void initState() {
    liked = BlocProvider.of<FavouritesCubit>(context).isLiked(widget.announcement.anouncesTableId);
    super.initState();
  }

  void onLikeTapped() {
    final localizations = AppLocalizations.of(context)!;
    BlocProvider.of<FavouritesCubit>(context).likeUnlike(widget.announcement.anouncesTableId);
    setState(() {
      CustomSnackBar.showSnackBar(
        context,
        liked ? localizations.adRemovedFromFavorites : localizations.adAddedToFavorites,
        2,
      );
      liked = !liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final double imageWidth = width / 2;
    final double imageHeight = width / 2 * 0.9;

    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutesNames.announcement,
            arguments: widget.announcement.anouncesTableId,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              width: imageWidth,
              height: imageHeight,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: widget.announcement.thumb != ''
                    ? widget.announcement.thumb
                    : widget.announcement.images.firstOrNull ?? '',
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: imageHeight,
                      width: imageWidth,
                      color: Colors.grey[300],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: imageWidth,
              child: Text(
                widget.announcement.title,
                style: AppTypography.font14dark,
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 5),
            BlocListener<FavouritesCubit, FavouritesState>(
              listener: (context, state) {
                if (state is LikeSuccessState && state.changedPostId == widget.announcement.anouncesTableId) {
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
                      SizedBox(
                        width: imageWidth * 0.8,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.announcement.stringPrice,
                            style: AppTypography.font16boldRed,
                            textDirection: TextDirection.ltr,
                          ),
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
            // Row(
            //   children: [
            //     Text(
            //       widget.announcement.creatorData.displayName,
            //       style: widget.announcement.creatorData.verified
            //           ? AppTypography.font12lightGray
            //               .copyWith(color: const Color(0xFF0F7EE4), fontWeight: FontWeight.w400)
            //           : AppTypography.font12lightGray.copyWith(fontWeight: FontWeight.w400),
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //     if (widget.announcement.creatorData.verified) ...[
            //       const SizedBox(width: 5),
            //       SvgPicture.asset(
            //         'Assets/icons/verified-user.svg',
            //         width: 12,
            //       )
            //     ]
            //   ],
            // ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset('Assets/icons/point.svg'),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    widget.announcement.city.name != ''
                        ? '${widget.announcement.city.name}, ${widget.announcement.area.name}'
                        : widget.announcement.area.name,
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
