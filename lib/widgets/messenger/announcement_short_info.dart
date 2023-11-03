import 'package:flutter/material.dart.';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';

class AnnouncementShortInfo extends StatelessWidget {
  const AnnouncementShortInfo({super.key, required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          ]),
      child: Row(
        children: [
          FutureBuilder(
              future: announcement.futureBytes,
              builder: (context, snapshot) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: snapshot.hasData
                      ? Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          width: 65,
                          height: 55,
                          frameBuilder:
                              ((context, child, frame, wasSynchronouslyLoaded) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: frame != null
                                  ? child
                                  : Container(
                                      height: 65,
                                      width: 55,
                                      color: Colors.grey[300],
                                    ),
                            );
                          }),
                        )
                      : Container(
                          height: 65,
                          width: 66,
                          color: Colors.grey[300],
                        ),
                );
              }),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}
