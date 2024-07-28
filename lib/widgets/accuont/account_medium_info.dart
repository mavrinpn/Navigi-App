import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/reviews/ui/widgets/user_score_widget.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/accuont/user_avatar.dart';

import '../../localization/app_localizations.dart';
import '../../models/user.dart';

class AccountMediumInfo extends StatefulWidget {
  const AccountMediumInfo({super.key, required this.user});

  final UserData user;

  @override
  State<AccountMediumInfo> createState() => _AccountMediumInfoState();
}

class _AccountMediumInfoState extends State<AccountMediumInfo> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(children: [
                UserAvatar(
                  size: 100,
                  imageUrl: widget.user.avatarImageUrl,
                  userName: widget.user.name,
                ),
                Container(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset(
                      'Assets/icons/isNotConfirmed.svg',
                      width: 24,
                      height: 24,
                    )),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 162,
                    child: Material(
                      color: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutesNames.reviews,
                            arguments: widget.user,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Wrap(
                            children: [
                              Text(
                                widget.user.displayName,
                                style: AppTypography.font20black,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(width: 10),
                              widget.user.rating != -1
                                  ? Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                          child: UserScoreWidget(
                                            score: widget.user.rating,
                                            subtitle: '',
                                            bigSize: false,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${localizations.onTheServiceOf} ${widget.user.atService}',
                    style: AppTypography.font12lightGray.copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
