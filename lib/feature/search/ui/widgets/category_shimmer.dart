import 'package:flutter/material.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final cardSize = (MediaQuery.of(context).size.width - 15 * 2 - 10 * 2) / 3;

    return Column(
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
          height: 12,
          width: cardSize * 0.55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 12,
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
