import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/bloc/app/app_cubit.dart';
import 'package:smart/feature/announcement/bloc/announcement/announcement_cubit.dart';
import 'package:smart/feature/announcement/ui/dialogs/offer_price_bottom_sheet.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/feature/messenger/chat_function.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/announcement_manager.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/button/custom_icon_button.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

class FloatContactsButtons extends StatefulWidget {
  const FloatContactsButtons({
    super.key,
    required this.state,
  });

  final AnnouncementSuccessState state;

  @override
  State<FloatContactsButtons> createState() => _FloatContactsButtonsState();
}

class _FloatContactsButtonsState extends State<FloatContactsButtons> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            CustomTextButton.withIcon(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              disableColor: AppColors.red,
              width: MediaQuery.of(context).size.width - 62,
              callback: () {
                final isUserAuth = context.read<AppCubit>().state is AppAuthState;
                if (!isUserAuth) {
                  Navigator.of(context).pushNamed(
                    AppRoutesNames.loginFirst,
                    arguments: {'showBackButton': true},
                  );
                  return;
                }
                incContactsIfNeed(widget.state);
                checkBlockedAndPushChat(
                  context: context,
                  data: widget.state.data,
                );
              },
              text: AppLocalizations.of(context)!.toWrite,
              styleText: AppTypography.font14white,
              icon: SvgPicture.asset(
                'Assets/icons/email.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: CustomIconButton(
                callback: () {
                  final isUserAuth = context.read<AppCubit>().state is AppAuthState;
                  if (!isUserAuth) {
                    Navigator.of(context).pushNamed(
                      AppRoutesNames.loginFirst,
                      arguments: {'showBackButton': true},
                    );
                    return;
                  }
                  incContactsIfNeed(widget.state);
                  checkBlockedAndCall(
                    context: context,
                    userId: widget.state.data.creatorData.uid,
                    phone: widget.state.data.creatorData.phone,
                  );
                },
                icon: 'Assets/icons/phone.svg',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CustomTextButton.withIcon(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          callback: () {
            final isUserAuth = context.read<AppCubit>().state is AppAuthState;
            if (!isUserAuth) {
              Navigator.of(context).pushNamed(
                AppRoutesNames.loginFirst,
                arguments: {'showBackButton': true},
              );
              return;
            }
            showOfferPriceDialog(
              context: context,
              announcement: widget.state.data,
            ).then((offerPriceString) {
              if (offerPriceString != null) {
                incContactsIfNeed(widget.state);
                checkBlockedAndPushChat(
                  // ignore: use_build_context_synchronously
                  context: context,
                  data: widget.state.data,
                  message: '${localizations.offerMessage} $offerPriceString',
                );
              }
            });
          },
          text: AppLocalizations.of(context)!.offrirVotrePrix,
          styleText: AppTypography.font14black,
          icon: SvgPicture.asset('Assets/icons/dzd.svg'),
        ),
      ],
    );
  }

  void incContactsIfNeed(AnnouncementSuccessState state) {
    final userId = RepositoryProvider.of<AuthRepository>(context).userId;
    if (userId != state.data.creatorData.uid) {
      RepositoryProvider.of<AnnouncementManager>(context).incContactsViews(state.data.anouncesTableId);
    }
  }
}
