// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/fonts.dart';

import '../../feature/announcement/bloc/announcement_cubit.dart';
import '../../utils/colors.dart';
import '../images/network_image.dart';

class AnnouncementContainer extends StatefulWidget {
  const AnnouncementContainer({super.key, required this.announcement});

  final Announcement announcement;

  @override
  State<AnnouncementContainer> createState() => _AnnouncementContainerState();
}

class _AnnouncementContainerState extends State<AnnouncementContainer> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () async {
        Navigator.pushNamed(context, '/announcement_screen');
        BlocProvider.of<AnnouncementCubit>(context)
            .loadAnnouncementById(widget.announcement.announcementId);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
              width: double.infinity, height: width / 2  - 52, url: widget.announcement.images[0]),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              widget.announcement.title,
              style: AppTypography.font12dark,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            widget.announcement.creatorData.name,
            style: AppTypography.font12lightGray,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('Assets/icons/point.svg'),
              RichText(
                maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(children: [
                TextSpan(
                    text: ' ${widget.announcement.creatorData.place.name}',
                    style: AppTypography.font14black),
                TextSpan(
                    text: '  ${widget.announcement.creatorData.distance}',
                    style: AppTypography.font14lightGray),
              ]))
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.announcement.stringPrice,
                  style: AppTypography.font16boldRed),
              InkWell(
                  focusColor: AppColors.empty,
                  hoverColor: AppColors.empty,
                  highlightColor: AppColors.empty,
                  splashColor: AppColors.empty,
                  onTap: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                  child: SvgPicture.asset('Assets/icons/follow.svg',
                      width: 24,
                      height: 24,
                      color: isLiked ? AppColors.red : AppColors.whiteGray))
            ],
          )
        ],
      ),
    );
  }
}
