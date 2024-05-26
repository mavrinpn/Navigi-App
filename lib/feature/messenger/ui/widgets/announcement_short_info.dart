import 'package:flutter/material.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';

class AnnouncementShortInfo extends StatelessWidget {
  const AnnouncementShortInfo({super.key, required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutesNames.announcement,
          arguments: announcement.anouncesTableId,
        );
      },
      child: Container(
        width: double.infinity,
        height: 75,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
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
            if (announcement.images.firstOrNull != null)
              Container(
                clipBehavior: Clip.hardEdge,
                width: 65,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Image.network(
                  announcement.images.first,
                  fit: BoxFit.cover,
                ),
              ),
            // AnnouncementImage(
            //   announcement: announcement,
            //   width: 65,
            //   height: 55,
            // ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.title,
                  style: AppTypography.font12dark,
                ),
                Text(
                  announcement.stringPrice,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.red,
                      fontWeight: FontWeight.w600),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
