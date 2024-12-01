import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/feature/messenger/data/messenger_repository.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/blocked_users_manager.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/snackBar/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> checkBlockedAndPushChat({
  required BuildContext context,
  required Announcement data,
  String? message,
}) async {
  final localizations = AppLocalizations.of(context)!;
  final userId = RepositoryProvider.of<AuthRepository>(context).userId;
  if (data.creatorData.uid == userId) {
    CustomSnackBar.showSnackBar(
      context,
      'Cette annonce est votre',
    );
    return;
  }

  final blocked = await RepositoryProvider.of<BlockedUsersManager>(context).isAuthUserBlockedFor(data.creatorData.uid);
  if (blocked) {
    CustomSnackBar.showSnackBar(context, localizations.chatBlocked);
  } else {
    RepositoryProvider.of<MessengerRepository>(context).selectChat(announcement: data);
    await Navigator.pushNamed(
      context,
      AppRoutesNames.chat,
      arguments: message,
    );
  }
}

void checkBlockedAndCall({
  required BuildContext context,
  required String userId,
  required String phone,
}) {
  final localizations = AppLocalizations.of(context)!;
  RepositoryProvider.of<BlockedUsersManager>(context).isAuthUserBlockedFor(userId).then((blocked) {
    if (blocked) {
      CustomSnackBar.showSnackBar(context, localizations.chatBlocked);
    } else {
      String localPhone = phone;
      if (!phone.startsWith('+')) {
        localPhone = '+213$phone';
      }
      launchUrl(Uri.parse('tel://$localPhone'));
    }
  });
}
