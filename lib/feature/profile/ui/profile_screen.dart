import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/profile/bloc/user_cubit.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/widgets/conatainers/announcementHorizontal.dart';

import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/accuont/account_medium_info.dart';
import '../../../widgets/button/custom_elevated_button.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../announcement/bloc/creator_cubit/creator_cubit.dart';
import '../../announcement/data/creator_repository.dart';
import '../../auth/bloc/auth_cubit.dart';
import '../../auth/data/auth_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final controller = ScrollController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final creatorManager = RepositoryProvider.of<CreatorRepository>(context);
    double getGridHeight() {
      int h;
      if (_tabController.index == 0) {
        h = min(creatorManager.availableAnnouncements!.length, 4);
      } else {
        h = min(creatorManager.soldAnnouncements!.length, 4);
      }
      return h >= 3
          ? 600
          : h >= 1
              ? 300
              : 100;
    }

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
            return BlocBuilder<CreatorCubit, CreatorState>(
              builder: (context, creatorState) {
                return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: AccountMediumInfo(
                            user: RepositoryProvider.of<AuthRepository>(context)
                                .userData,
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 40,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: CustomTextButton.withIcon(
                            callback: () {
                              Navigator.pushNamed(
                                  context, '/create_category_screen');
                            },
                            text: AppLocalizations.of(context)!.addAnnouncement,
                            styleText: AppTypography.font14white,
                            active: true,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                              width: 190,
                              color: Colors.white,
                              alignment: Alignment.center,
                              child: TabBar(
                                labelColor: Colors.black,
                                indicatorColor: Colors.black,
                                indicatorWeight: 2,
                                unselectedLabelColor: AppColors.lightGray,
                                indicator: const UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                        color: AppColors.red, width: 2),
                                    insets:
                                        EdgeInsets.symmetric(horizontal: 20)),
                                onTap: (int val) {
                                  setState(() {});
                                },
                                controller: _tabController,
                                tabs: [
                                  Tab(
                                    child: Text(
                                        'Actif (${creatorState is CreatorSuccessState ? creatorState.available.length : 0})',
                                        style: AppTypography.font24black
                                            .copyWith(
                                                fontSize: 14,
                                                color: _tabController.index == 0
                                                    ? Colors.black
                                                    : Colors.grey)),
                                  ),
                                  Tab(
                                    child: Text(
                                        'Vendu (${creatorState is CreatorSuccessState ? creatorState.sold.length : 0})',
                                        style: AppTypography.font24black
                                            .copyWith(
                                                fontSize: 14,
                                                color: _tabController.index == 1
                                                    ? Colors.black
                                                    : Colors.grey)),
                                  ),
                                ],
                              )),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 15,
                          ),
                        ),
                        if (creatorState is CreatorSuccessState) ...[
                          getGridHeight() == 100
                              ? const SliverPadding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                                  sliver: SliverToBoxAdapter(
                                    child: Center(
                                      child: Text(
                                        'Vous n\'avez pas d\'annonces',
                                        style: TextStyle(
                                          color: Color(0xFF9B9FAA),
                                          fontSize: 14,
                                          fontFamily: 'SF Pro Display',
                                          fontWeight: FontWeight.w400,
                                          height: 0.09,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SliverList.builder(

                                  itemCount: _tabController.index == 0
                                      ? min(creatorState.available.length, 4)
                                      : min(creatorState.sold.length, 4),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return AnnouncementContainerHorizontal(
                                        announcement: _tabController.index == 0
                                            ? creatorState.available[index]
                                            : creatorState.sold[index], viewCount: '13', likeCount: '13', userCount: '13',);
                                  })
                        ] else ...[
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: AppAnimations.circleFadingAnimation,
                            ),
                          )
                        ],
                        SliverToBoxAdapter(
                          child: RowButton(
                            title: localizations.myInformations,
                            icon: 'Assets/icons/profile_settings.svg',
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/edit_profile_screen');
                            },
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: RowButton(
                            title: localizations.myComments,
                            icon: 'Assets/icons/messages.svg',
                            onTap: () {},
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: RowButton(
                            title: localizations.fAQ,
                            icon: 'Assets/icons/faq.svg',
                            onTap: () {},
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: RowButton(
                            title: localizations.privacyPolicy,
                            icon: 'Assets/icons/security.svg',
                            onTap: () {},
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: RowButton(
                            title: 'Conditions dutilisation',
                            icon: 'Assets/icons/terms_of_use.svg',
                            onTap: () {},
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 20,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: CustomElevatedButton(
                              icon: "Assets/icons/exit.svg",
                              title: "Se déconnecter du compte",
                              onPress: () {
                                BlocProvider.of<AuthCubit>(context).logout();
                              },
                              height: 52,
                              width: double.infinity),
                        )
                      ],
                    ));
              },
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
