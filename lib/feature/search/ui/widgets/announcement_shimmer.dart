import 'package:flutter/material.dart';

class AnnouncementShimmer extends StatelessWidget {
  const AnnouncementShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double cardSize = width / 2 - 25;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: cardSize,
          width: cardSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 16,
          width: cardSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 20,
          width: cardSize * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 16,
          width: cardSize * 0.25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 16,
          width: cardSize * 0.75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
