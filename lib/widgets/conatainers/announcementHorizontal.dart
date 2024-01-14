import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../../feature/announcement/bloc/announcement/announcement_cubit.dart';
import '../../utils/colors.dart';

class AnnouncementContainerHorizontal extends StatefulWidget {
  const AnnouncementContainerHorizontal(
      {super.key,
      required this.announcement,
      this.width,
      this.height,
      required this.viewCount,
      required this.likeCount,
      required this.userCount});

  final double? width, height;
  final Announcement announcement;
  final String viewCount;
  final String likeCount;
  final String userCount;

  @override
  State<AnnouncementContainerHorizontal> createState() =>
      _AnnouncementContainerHorizontalState();
}

class _AnnouncementContainerHorizontalState
    extends State<AnnouncementContainerHorizontal> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double imageWidth = widget.width ?? width / 2 - 25;
    final double imageHeight = widget.height ?? (width / 2 - 25) * 1.032;

    return InkWell(
        focusColor: AppColors.empty,
        hoverColor: AppColors.empty,
        highlightColor: AppColors.empty,
        splashColor: AppColors.empty,
        onTap: () async {
          BlocProvider.of<AnnouncementCubit>(context)
              .loadAnnouncementById(widget.announcement.id);
          Navigator.pushNamed(context, AppRoutesNames.announcement);
        },
        child: Container(
          height: 118,
          width: double.infinity,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: FutureBuilder(
                    future: widget.announcement.futureBytes,
                    builder: (context, snapshot) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: snapshot.hasData
                            ? Image.memory(
                                widget.announcement.bytes,
                                fit: BoxFit.cover,
                                width: imageWidth,
                                height: imageHeight,
                                frameBuilder: ((context, child, frame,
                                    wasSynchronouslyLoaded) {
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: frame != null
                                        ? child
                                        : Container(
                                            height: imageHeight,
                                            width: imageWidth,
                                            color: Colors.grey[300],
                                          ),
                                  );
                                }),
                              )
                            : Container(
                                height: imageHeight,
                                width: imageWidth,
                                color: Colors.grey[300],
                              ),
                      );
                    }),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                      height: 6,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'Assets/icons/eye.svg',
                          width: 16,
                          fit: BoxFit.fitWidth,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          widget.viewCount,
                          style: AppTypography.font12black
                              .copyWith(color: AppColors.lightGray),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SvgPicture.asset(
                          'Assets/icons/profile.svg',
                          width: 16,
                          fit: BoxFit.fitWidth,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          widget.userCount,
                          style: AppTypography.font12black
                              .copyWith(color: AppColors.lightGray),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SvgPicture.asset(
                          'Assets/icons/follow.svg',
                          color: AppColors.lightGray,
                          width: 16,
                          fit: BoxFit.fitWidth,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          widget.likeCount,
                          style: AppTypography.font12black
                              .copyWith(color: AppColors.lightGray),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 240,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.announcement.stringPrice,
                            style: AppTypography.font16boldRed,
                            textDirection: TextDirection.ltr,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutesNames.editingAnnouncement);
                            },
                            child: SvgPicture.asset(
                              'Assets/icons/three_dots.svg',
                              color: AppColors.lightGray,
                              width: 16,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
