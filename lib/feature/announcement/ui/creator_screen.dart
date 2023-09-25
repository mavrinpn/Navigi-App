import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/announcement/bloc/creator_cubit/creator_cubit.dart';
import 'package:smart/feature/announcement/data/creator_repository.dart';
import 'package:smart/feature/profile/bloc/user_cubit.dart';
import 'package:smart/utils/animations.dart';

import '../../../managers/favourits_manager.dart';
import '../../../models/announcement.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/accuont/account_medium_info.dart';
import '../../../widgets/button/custom_elevated_button.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../../widgets/conatainers/announcement.dart';
import '../../auth/bloc/auth_cubit.dart';
import '../../auth/data/auth_repository.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatorProfileScreen extends StatefulWidget {
  const CreatorProfileScreen({super.key});

  @override
  State<CreatorProfileScreen> createState() => _CreatorProfileScreenState();
}

class _CreatorProfileScreenState extends State<CreatorProfileScreen>
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
    final creatorManager = RepositoryProvider.of<CreatorRepository>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
          ),
        ),
        backgroundColor: AppColors.mainBackground,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/settings_screen');
              },
              child: SvgPicture.asset(
                'Assets/icons/menu_dots_vertical.svg',
                width: 24,
                height: 24,
                // ignore: deprecated_member_use
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocBuilder<CreatorCubit, CreatorState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: AccountMediumInfo(
                    user:
                        RepositoryProvider.of<CreatorRepository>(context).userData!
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 26,
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomTextButton.withIcon(
                    callback: () {},
                    text: 'Écrire',
                    styleText: AppTypography.font14white,
                    isTouch: true,
                    icon: const Icon(
                      Icons.mail_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomTextButton.withIcon(
                    callback: () {},
                    text: 'Appeler',
                    styleText: AppTypography.font14white,
                    isTouch: true,
                    activeColor: AppColors.dark,
                    icon: const Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 25,
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
                            borderSide:
                                BorderSide(color: AppColors.red, width: 2),
                            insets: EdgeInsets.symmetric(horizontal: 20)),
                        onTap: (int val) {
                          setState(() {});
                        },
                        controller: _tabController,
                        tabs: [
                          Tab(
                            child: Text(
                                'Actif (${state is CreatorSuccessState ? creatorManager.availableAnnouncements!.length : 0})',
                                style: AppTypography.font24black.copyWith(
                                    fontSize: 14,
                                    color: _tabController.index == 0
                                        ? Colors.black
                                        : Colors.grey)),
                          ),
                          Tab(
                            child: Text(
                                'Vendu (${state is CreatorSuccessState ? creatorManager.soldAnnouncements!.length : 0})',
                                style: AppTypography.font24black.copyWith(
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
                if (state is CreatorSuccessState) ...[
                  SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Container(
                          color: AppColors.mainBackground,
                          child: Center(
                            child: AnnouncementContainer(
                                announcement: _tabController.index == 0
                                    ? creatorManager.availableAnnouncements![index]
                                    : creatorManager.soldAnnouncements![index]),
                          ),
                        ),
                        childCount: (_tabController.index == 0
                            ? creatorManager.availableAnnouncements!.length
                            : creatorManager.soldAnnouncements!.length),
                      ),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 16,
                          maxCrossAxisExtent:
                              MediaQuery.of(context).size.width / 2,
                          childAspectRatio: 160 / 272)),
                ] else ...[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: AppAnimations.circleFadingAnimation,
                    ),
                  ),
                ]
              ],
            );
          },
        ),
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
