import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/announcement/bloc/creator_cubit/creator_cubit.dart';
import 'package:smart/feature/announcement_editing/bloc/announcement_edit_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/announcement_manager.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/dialogs.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../../../../utils/fonts.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({super.key, required this.announcement});

  final Announcement announcement;

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  late final AnnouncementManager announcementManager;
  late final CreatorCubit creatorCubit;

  @override
  void initState() {
    announcementManager = RepositoryProvider.of<AnnouncementManager>(context);
    creatorCubit = BlocProvider.of<CreatorCubit>(context);
    super.initState();
  }

  void changeActivity() {
    announcementManager.changeActivity(widget.announcement.id).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('success')));
      creatorCubit.setUserId(widget.announcement.creatorData.uid);
    });
  }

  void openEditing() {
    context
        .read<AnnouncementEditCubit>()
        .setAnnouncement(widget.announcement)
        .then((value) =>
            Navigator.pushNamed(context, AppRoutesNames.editingAnnouncement));
  }

  void deleteAnnouncement() {
    Dialogs.showModal(context, AppAnimations.circleFadingAnimation);
    try {
      context
          .read<AnnouncementEditCubit>()
          .deleteAnnouncement(widget.announcement)
          .then((value) {
        Dialogs.hide(context);
        Navigator.popUntil(context, ModalRoute.withName(AppRoutesNames.root));
      });
    } catch (e) {
      Dialogs.hide(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          RowSettingsButton(onTap: changeActivity, children: [
            const Icon(
              Icons.edit,
              color: Colors.black,
              size: 24,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              'Change activity',
              style: AppTypography.font18black,
            )
          ]),
          RowSettingsButton(onTap: openEditing, children: [
            const Icon(
              Icons.edit,
              color: Colors.black,
              size: 24,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              localizations.edit,
              style: AppTypography.font18black,
            )
          ]),
          RowSettingsButton(onTap: deleteAnnouncement, children: [
            const Icon(
              Icons.edit,
              color: Colors.black,
              size: 24,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              'Delete',
              style: AppTypography.font18black,
            )
          ]),
        ],
      ),
    );
  }
}

class RowSettingsButton extends StatelessWidget {
  const RowSettingsButton(
      {super.key, required this.children, required this.onTap});

  final List<Widget> children;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: children,
        ),
      ),
    );
  }
}
