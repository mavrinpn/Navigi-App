import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:smart/feature/announcement/ui/widgets/additional_menu_bottom_sheet.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/blocked_users_manager.dart';
import 'package:smart/utils/app_icons_icons.dart';
import 'package:smart/utils/email_templates.dart';
import 'package:smart/utils/fonts.dart';

void creatorShowMoreAction({
  required BuildContext context,
  required String userId,
  required Function(bool blocked) onAction,
}) async {
  final localizations = AppLocalizations.of(context)!;
  final blockedUsersManager = RepositoryProvider.of<BlockedUsersManager>(context);

  blockedUsersManager.isUserBlockedForAuth(userId).then((isBlocked) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      showDragHandle: true,
      builder: (ctx) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              RowSettingsButton(
                onTap: () {
                  if (isBlocked) {
                    blockedUsersManager.unblock(userId);
                  } else {
                    blockedUsersManager.block(userId);
                  }
                  onAction(!isBlocked);
                  Navigator.of(context).pop();
                },
                children: [
                  const Icon(
                    AppIcons.block,
                    color: Colors.black,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isBlocked ? localizations.unblockUser : localizations.blockUser,
                    style: AppTypography.font18black,
                  )
                ],
              ),
              RowSettingsButton(
                onTap: () {
                  //TODO
                  FlutterEmailSender.send(EmailTemplates.reportEmail(userId));
                },
                children: [
                  const Icon(
                    AppIcons.attention,
                    color: Colors.black,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    localizations.report,
                    style: AppTypography.font18black,
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  });
}
