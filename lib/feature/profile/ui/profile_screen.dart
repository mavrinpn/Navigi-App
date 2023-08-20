import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/profile/bloc/user_cubit.dart';
import 'package:smart/utils/animations.dart';

import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/accuont/account_medium_info.dart';
import '../../../widgets/button/custom_elevated_button.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../auth/bloc/auth_cubit.dart';
import '../../auth/data/auth_repository.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.mainBackground,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(localizations.myProfile, style: AppTypography.font20black),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/settings_screen');
              },
              child: SvgPicture.asset(
                'Assets/icons/setting.svg',
                width: 24,
                height: 24,
                // ignore: deprecated_member_use
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is ProfileSuccessState ||
              state is EditSuccessState ||
              state is EditFailState) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AccountMediumInfo(
                      user: RepositoryProvider.of<AuthRepository>(context)
                          .userData,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CustomTextButton.withIcon(
                      callback: () {
                        Navigator.pushNamed(context, '/create_category_screen');
                      },
                      text: AppLocalizations.of(context)!.addAnnouncement,
                      styleText: AppTypography.font14white,
                      isTouch: true,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    RowButton(
                      title: localizations.myInformations,
                      icon: 'Assets/icons/profile_settings.svg',
                      onTap: () {
                        Navigator.pushNamed(context, '/edit_profile_screen');
                      },
                    ),
                    RowButton(
                      title: localizations.myComments,
                      icon: 'Assets/icons/messages.svg',
                      onTap: () {},
                    ),
                    RowButton(
                      title: localizations.fAQ,
                      icon: 'Assets/icons/faq.svg',
                      onTap: () {},
                    ),
                    RowButton(
                      title: localizations.privacyPolicy,
                      icon: 'Assets/icons/security.svg',
                      onTap: () {},
                    ),
                    RowButton(
                      title: 'Conditions dutilisation',
                      icon: 'Assets/icons/terms_of_use.svg',
                      onTap: () {},
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomElevatedButton(
                        icon: "Assets/icons/exit.svg",
                        title: "Se déconnecter du compte",
                        onPress: () {
                          BlocProvider.of<AuthCubit>(context).logout();
                        },
                        height: 52,
                        width: double.infinity)
                  ],
                ),
              ),
            );
          } else {
            return Center(child: AppAnimations.circleFadingAnimation);
          }
        },
      ),
    );
  }
}

class RowButton extends StatelessWidget {
  const RowButton(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  final String icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        focusColor: AppColors.empty,
        hoverColor: AppColors.empty,
        highlightColor: AppColors.empty,
        splashColor: AppColors.empty,
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.backgroundIcon),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(
                    icon,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      title,
                      style: AppTypography.font14black
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
