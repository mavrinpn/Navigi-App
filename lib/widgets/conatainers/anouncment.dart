import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/fonts.dart';

class AnnouncementContainer extends StatelessWidget {
  const AnnouncementContainer({super.key, required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
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
            Container(
              width: 108,
              height: 98,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(announcement.imageUrl),
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
              ),
            ),
            const SizedBox(width: 10,),
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
                        child: Text(
                          announcement.title,
                          style: AppTypography.font12dark
                        ),
                      ),
                      SvgPicture.asset('Assets/icons/follow_2.svg', width: 24)
                    ],
                  ),
                  const SizedBox(height: 8,),
                  Text(
                   announcement.creatorName,
                    style: AppTypography.font12lightGray
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        announcement.stringPrice,
                        style: AppTypography.font16boldRed
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
