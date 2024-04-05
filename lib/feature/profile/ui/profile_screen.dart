import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/profile/bloc/user_cubit.dart';
import 'package:smart/feature/profile/ui/widgets/row_button.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/creating_announcement_manager.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/restart_controller.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/conatainers/announcement_horizontal.dart';

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

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showAll = false;
  List<Announcement> _available = [];
  List<Announcement> _sold = [];
  String _loggedUserId = '';

  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final creatorManager = RepositoryProvider.of<CreatorRepository>(context);
    double getGridHeight() {
      int h;
      if (_tabController.index == 0) {
        h = min(creatorManager.availableAnnouncements.length, 4);
      } else {
        h = min(creatorManager.soldAnnouncements.length, 4);
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
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(width: 15),
            Expanded(
              child: Text(localizations.profile, style: AppTypography.font20black),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutesNames.settings);
              },
              icon: SvgPicture.asset(
                'Assets/icons/setting.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomTextButton.withIcon(
        callback: () {
          final creatingManager = context.read<CreatingAnnouncementManager>();
          creatingManager.isCreating = true;
          Navigator.pushNamed(context, AppRoutesNames.announcementCreatingCategory);
        },
        width: MediaQuery.of(context).size.width - 30,
        text: AppLocalizations.of(context)!.addAnAd,
        styleText: AppTypography.font14white,
        active: true,
        icon: const Icon(
          Icons.add,
          color: Colors.white,
          size: 24,
        ),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is ProfileSuccessState || state is EditSuccessState || state is EditFailState) {
            return BlocBuilder<CreatorCubit, CreatorState>(
              builder: (context, creatorState) {
                _loggedUserId = RepositoryProvider.of<AuthRepository>(context).userData?.id ?? '';

                if (creatorState is CreatorSuccessState) {
                  if (creatorState.available.firstOrNull?.creatorData.uid == _loggedUserId) {
                    _available = [...creatorState.available];
                    _sold = [...creatorState.sold];
                  }
                }

                return CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      sliver: SliverToBoxAdapter(
                        child: RepositoryProvider.of<AuthRepository>(context).userData != null
                            ? AccountMediumInfo(
                                user: RepositoryProvider.of<AuthRepository>(context).userData!,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    SliverToBoxAdapter(
                      child: TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: Colors.black,
                        indicatorColor: Colors.black,
                        indicatorWeight: 2,
                        dividerHeight: 0,
                        unselectedLabelColor: AppColors.lightGray,
                        splashBorderRadius: BorderRadius.circular(12),
                        indicator: const UnderlineTabIndicator(
                            borderSide: BorderSide(color: AppColors.red, width: 4),
                            insets: EdgeInsets.symmetric(horizontal: 60)),
                        onTap: (int val) => setState(() {}),
                        controller: _tabController,
                        tabs: [
                          Tab(
                            child: Text(
                                '${localizations.active} (${creatorState is CreatorSuccessState ? creatorState.available.length : 0})',
                                style: AppTypography.font24black.copyWith(
                                    fontSize: 14, color: _tabController.index == 0 ? Colors.black : Colors.grey)),
                          ),
                          Tab(
                            child: Text(
                                '${localizations.sold} (${creatorState is CreatorSuccessState ? creatorState.sold.length : 0})',
                                style: AppTypography.font24black.copyWith(
                                    fontSize: 14, color: _tabController.index == 1 ? Colors.black : Colors.grey)),
                          ),
                        ],
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 15)),
                    if (creatorState is CreatorSuccessState || (_available.isNotEmpty)) ...[
                      getGridHeight() == 100
                          ? SliverPadding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              sliver: SliverToBoxAdapter(
                                child: Center(
                                  child: Text(
                                    localizations.youHaveNoAds,
                                    style: const TextStyle(
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
                          : SliverList.separated(
                              itemCount: _tabController.index == 0
                                  ? _showAll
                                      ? _available.length
                                      : min(_available.length, 4)
                                  : _showAll
                                      ? _sold.length
                                      : min(_sold.length, 4),
                              itemBuilder: (BuildContext context, int index) {
                                return AnnouncementContainerHorizontal(
                                    announcement: _tabController.index == 0 ? _available[index] : _sold[index],
                                    likeCount: '13');
                              },
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                            )
                    ],
                    if (creatorState is CreatorLoadingState && (_available.isEmpty)) ...[
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 100,
                          width: 50,
                          child: AppAnimations.circleFadingAnimation,
                        ),
                      )
                    ],
                    if (!_showAll && (creatorState is CreatorSuccessState && creatorState.available.length > 4))
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                        sliver: SliverToBoxAdapter(
                          child: CustomTextButton.orangeContinue(
                            callback: () {
                              setState(() {
                                _showAll = true;
                              });
                            },
                            text: AppLocalizations.of(context)!.showAll,
                            styleText: AppTypography.font14black,
                            active: true,
                            activeColor: AppColors.backgroundLightGray,
                          ),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 15)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      sliver: SliverToBoxAdapter(
                        child: RowButton(
                          title: localizations.myData,
                          icon: 'Assets/icons/profile_settings.svg',
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutesNames.editProfile,
                            );
                          },
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      sliver: SliverToBoxAdapter(
                        child: RowButton(
                          title: localizations.myComments,
                          icon: 'Assets/icons/messages.svg',
                          onTap: () {},
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      sliver: SliverToBoxAdapter(
                        child: RowButton(
                          title: localizations.faq,
                          icon: 'Assets/icons/faq.svg',
                          onTap: () {},
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      sliver: SliverToBoxAdapter(
                        child: RowButton(
                          title: localizations.privacyPolicy,
                          icon: 'Assets/icons/security.svg',
                          onTap: () {},
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      sliver: SliverToBoxAdapter(
                        child: RowButton(
                          title: localizations.termsOfUse,
                          icon: 'Assets/icons/terms_of_use.svg',
                          onTap: () {},
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 20),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      sliver: SliverToBoxAdapter(
                        child: CustomElevatedButton(
                          icon: "Assets/icons/exit.svg",
                          title: localizations.disconnectFromTheAccount,
                          onPress: () => _logoutButton(),
                          height: 52,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 90)),
                  ],
                );
              },
            );
          } else {
            return Center(child: AppAnimations.circleFadingAnimation);
          }
        },
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
                setState(() {
                  _available = [];
                  _sold = [];
                });

                BlocProvider.of<AuthCubit>(context).logout().then((value) {
                  //TODO logout
                  HotRestartController.performHotRestart(context);
                });
                Navigator.of(context).pop();
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
