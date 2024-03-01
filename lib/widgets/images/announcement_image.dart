import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:smart/models/announcement.dart';

class AnnouncementImage extends StatelessWidget {
  const AnnouncementImage(
      {super.key,
      required this.announcement,
      required this.width,
      required this.height});

  final Announcement announcement;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: announcement.futureBytes,
        builder: (context, snapshot) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: snapshot.hasData
                ? Image.memory(
                    announcement.bytes ?? Uint8List(0),
                    fit: BoxFit.cover,
                    width: width,
                    height: height,
                    frameBuilder:
                        ((context, child, frame, wasSynchronouslyLoaded) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: frame != null
                            ? child
                            : Container(
                                height: height,
                                width: width,
                                color: Colors.grey[300],
                              ),
                      );
                    }),
                  )
                : Container(
                    height: height,
                    width: width,
                    color: Colors.grey[300],
                  ),
          );
        });
  }
}
