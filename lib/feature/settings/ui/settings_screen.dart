import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/announcement/bloc/creator_cubit/creator_cubit.dart';
import 'package:smart/feature/auth/bloc/auth_cubit.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/feature/profile/ui/widgets/row_button.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/restart_controller.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/button/back_button.dart';
import 'package:smart/widgets/button/custom_elevated_button.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

import '../../../models/custom_locate.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

List<CustomLocate> listLocates = [
  CustomLocate.fr(),
  CustomLocate.ar(),
];

class _SettingsScreenState extends State<SettingsScreen> {
  CustomLocate? customLocate;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    customLocate = CustomLocate(
        shortName: localizations.localeName,
        name: localizations.localeName == 'ar' ? CustomLocate.ar().name : CustomLocate.fr().name);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appBarColor,
        elevation: 0,
        titleSpacing: 6,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomBackButton(),
            Expanded(
              child: Text(
                localizations.placeApplicationSettings,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: AppTypography.font20black,
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RowButton(
              title: localizations.notifications,
              icon: 'Assets/icons/notifications.svg',
              onTap: () {},
            ),
            RowButton(
              title: localizations.language,
              icon: 'Assets/icons/language.svg',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutesNames.settingsLanguage,
                );
              },
            ),
            RowButton(
              title: localizations.myData,
              icon: 'Assets/icons/profile_settings.svg',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutesNames.editProfile,
                );
              },
            ),
            RowButton(
              title: localizations.myComments,
              icon: 'Assets/icons/messages.svg',
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutesNames.reviews,
                  arguments: RepositoryProvider.of<AuthRepository>(context).userData!,
                );
              },
            ),
            RowButton(
              title: localizations.faq,
              icon: 'Assets/icons/faq.svg',
              onTap: () {},
            ),
            RowButton(
              title: localizations.privacyPolicy,
              icon: 'Assets/icons/security.svg',
              onTap: () {},
            ),
            RowButton(
              title: localizations.termsOfUse,
              icon: 'Assets/icons/terms_of_use.svg',
              onTap: () {},
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              icon: "Assets/icons/exit.svg",
              title: localizations.disconnectFromTheAccount,
              onPress: () => _logoutButton(),
              height: 52,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  void _logoutButton() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Center(
              child: Text(
            'Vous voulez sortir?',
            style: AppTypography.font16black,
          )),
          content: Text(
            'Pharetra ultricies ullamcorper a et magna convallis condimentum. Proin mi orci dignissim lectus nulla neque elitInt',
            textAlign: TextAlign.center,
            style: AppTypography.font14lightGray,
          ),
          actions: [
            CustomTextButton.orangeContinue(
              callback: () {
                BlocProvider.of<CreatorCubit>(context).setUserId('');

                BlocProvider.of<AuthCubit>(context).logout().then((value) {
                  HotRestartController.performHotRestart(context);
                });
                Navigator.popUntil(context, ModalRoute.withName(AppRoutesNames.root));
              },
              styleText: AppTypography.font14black.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              text: 'Oui',
              active: true,
              activeColor: AppColors.black,
            ),
            const SizedBox(height: 10),
            CustomTextButton.shadow(
              callback: () {
                Navigator.of(context).pop();
              },
              styleText: AppTypography.font14black.copyWith(fontWeight: FontWeight.bold),
              text: 'Non',
              active: true,
              activeColor: Colors.white,
            )
          ],
        );
      },
    );
  }
}
