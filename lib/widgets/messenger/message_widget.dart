import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/models/messenger/message.dart';
import 'package:smart/utils/fonts.dart';

import '../../utils/colors.dart';

class MessageContainer extends StatelessWidget {
  const MessageContainer({
    super.key,
    required this.text,
    required this.isCurrentUser,
  });

  final String text;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: !isCurrentUser ? AppColors.backgroundLightGray : AppColors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: AppTypography.font12dark.copyWith(
              color: !isCurrentUser ? Colors.black87 : Colors.white,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
