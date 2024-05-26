import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/announcement/ui/widgets/additional_menu_bottom_sheet.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/feature/favorites/bloc/favourites_cubit.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../../utils/colors.dart';

class AnnouncementContainerHorizontal extends StatefulWidget {
  const AnnouncementContainerHorizontal({
    super.key,
    required this.announcement,
    this.width,
    this.height,
  });

  final double? width, height;
  final Announcement announcement;

  @override
  State<AnnouncementContainerHorizontal> createState() => _AnnouncementContainerHorizontalState();
}

class _AnnouncementContainerHorizontalState extends State<AnnouncementContainerHorizontal> {
  bool liked = false;
  int? _likeCount;

  @override
  void initState() {
    super.initState();
    final favouritesManager = context.read<FavouritesCubit>().favouritesManager;
    favouritesManager.count(widget.announcement.anouncesTableId).then((value) {
      setState(() {
        _likeCount = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double imageWidth = widget.width ?? width / 2 - 25;
    // final double imageHeight = widget.height ?? (width / 2 - 25) * 1.032;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutesNames.announcement,
          arguments: widget.announcement.anouncesTableId,
        );
      },
      child: Container(
        height: 118,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadows: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 18)]),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Container(
              width: 100,
              height: 100,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.announcement.images.firstOrNull,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'Assets/icons/eye.svg',
                          width: 16,
                          fit: BoxFit.fitWidth,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.announcement.totalViews.toString(),
                          style: AppTypography.font12gray.copyWith(color: AppColors.lightGray),
                        ),
                        const SizedBox(width: 20),
                        SvgPicture.asset(
                          'Assets/icons/person.svg',
                          width: 12,
                          fit: BoxFit.fitWidth,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.announcement.contactsViews.toString(),
                          style: AppTypography.font12gray.copyWith(color: AppColors.lightGray),
                        ),
                        const SizedBox(width: 20),
                        SvgPicture.asset(
                          'Assets/icons/follow.svg',
                          width: 16,
                          fit: BoxFit.fitWidth,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _likeCount != null ? _likeCount.toString() : '',
                          style: AppTypography.font12gray.copyWith(color: AppColors.lightGray),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.announcement.stringPrice,
                          style: AppTypography.font16boldRed,
                          textDirection: TextDirection.ltr,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            if (widget.announcement.creatorData.uid ==
                                RepositoryProvider.of<AuthRepository>(context).userId) {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  showDragHandle: true,
                                  builder: (ctx) {
                                    return AdditionalMenuBottomSheet(announcement: widget.announcement);
                                  });
                            }
                          },
                          icon: SizedBox(
                            height: 20,
                            width: 20,
                            child: SvgPicture.asset(
                              'Assets/icons/three_dots.svg',
                              fit: BoxFit.fitWidth,
                              colorFilter: const ColorFilter.mode(
                                AppColors.lightGray,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
