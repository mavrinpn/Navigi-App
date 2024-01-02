import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/utils/colors.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem(
      {super.key,
        required this.name,
        required this.deleteCallback,
        required this.setSearchCallback});

  final String name;
  final VoidCallback deleteCallback;
  final VoidCallback setSearchCallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: InkWell(
        onTap: setSearchCallback,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundIcon,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 30,
              height: 30,
              child: Center(
                child: SvgPicture.asset(
                  'Assets/icons/time.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name),
                  InkWell(
                    onTap: deleteCallback,
                    child: SvgPicture.asset(
                      'Assets/icons/dagger.svg',
                      width: 25,
                      height: 25,
                    ),
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