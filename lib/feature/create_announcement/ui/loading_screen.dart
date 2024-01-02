import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/announcement/bloc/creator_cubit/creator_cubit.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/managers/announcement_manager.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../bloc/creating/creating_announcement_cubit.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return WillPopScope(
      child: BlocListener<CreatingAnnouncementCubit, CreatingAnnouncementState>(
        listener: (context, state) {
          if (state is CreatingSuccessState) {
            BlocProvider.of<CreatorCubit>(context)
                .setUserId(RepositoryProvider.of<AuthRepository>(context).userId);
            log('абоаба');
            RepositoryProvider.of<AnnouncementManager>(context)
                .addLimitAnnouncements(true);
            Navigator.of(context).popUntil(ModalRoute.withName(AppRoutesNames.root));
          }
          if (state is CreatingFailState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('ошибка')));
            Navigator.of(context).popUntil(ModalRoute.withName(AppRoutesNames.root));
          }
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppAnimations.circleFadingAnimation,
                const SizedBox(
                  height: 44,
                ),
                Text(
                  'La modération de l\'annonce est en cours',
                  textAlign: TextAlign.center,
                  style: AppTypography.font24dark,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                    'Ne bloquez pas l\'application pendant le traitement de votre annonce',
                    textAlign: TextAlign.center,
                    style: AppTypography.font14light),
                const SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
