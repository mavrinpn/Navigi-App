import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';

import '../../feature/announcement/bloc/announcement_cubit.dart';
import '../../feature/main/bloc/announcement_manager.dart';
import '../images/network_image.dart';

class AnnouncementContainer extends StatefulWidget {
  AnnouncementContainer({super.key, required this.announcement});

  final Announcement announcement;
  bool liked = false;

  @override
  State<AnnouncementContainer> createState() => _AnnouncementContainerState();
}

class _AnnouncementContainerState extends State<AnnouncementContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTap: () async{
          Navigator.pushNamed(context, '/announcement_screen');
          BlocProvider.of<AnnouncementCubit>(context).loadAnnouncementById(widget.announcement.announcementId);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 118,
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
            children: [
              CustomNetworkImage(width: 108, height: 98, url: widget.announcement.images[0]),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 173,
                          child: Text(widget.announcement.title,
                              style: AppTypography.font12dark),
                        ),
                        InkWell(
                          child: SvgPicture.asset(
                            'Assets/icons/follow_2.svg',
                            width: 24,
                            color: widget.liked
                                ? AppColors.red
                                : AppColors.whiteGray,
                          ),
                          onTap: () {
                            setState(() {
                              widget.liked = !widget.liked;
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(widget.announcement.creatorData.name,
                        style: AppTypography.font12lightGray),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(widget.announcement.stringPrice,
                            style: AppTypography.font16boldRed),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
