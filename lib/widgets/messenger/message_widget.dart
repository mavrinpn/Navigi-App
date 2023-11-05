import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/models/messenger/message.dart';
import 'package:smart/utils/fonts.dart';

import '../../utils/colors.dart';




class MessengerContainer extends StatelessWidget {
  const MessengerContainer({super.key,
    required this.text,
    required this.isCurrentUser,
  });

  final String text;
  final bool isCurrentUser;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isCurrentUser ? AppColors.backgroundLightGray : AppColors.red,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: isCurrentUser ? Colors.black87 : Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
