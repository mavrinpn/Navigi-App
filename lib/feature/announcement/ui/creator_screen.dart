import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/announcement/bloc/creator_cubit/creator_cubit.dart';
import 'package:smart/feature/announcement/data/creator_repository.dart';
import 'package:smart/feature/announcement/ui/widgets/tabs.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/button/back_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../localization/app_localizations.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/accuont/account_medium_info.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../../widgets/conatainers/announcement_container.dart';

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
    final localizations = AppLocalizations.of(context)!;

    Widget buildAnnouncementsGrid(CreatorSuccessState state) {
      return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              color: AppColors.mainBackground,
              child: Center(
                child: AnnouncementContainer(
                    announcement: _tabController.index == 0
                        ? state.available[index]
                        : state.sold[index]),
              ),
            ),
            childCount: (_tabController.index == 0
                ? state.available.length
                : state.sold.length),
          ),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 18,
            mainAxisSpacing: 16,
            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
            childAspectRatio: 160 / 272,
          ));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: const CustomBackButton(),
        backgroundColor: AppColors.mainBackground,
        elevation: 0,
        titleSpacing: 6,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutesNames.settings);
              },
              child: SvgPicture.asset(
                'Assets/icons/menu_dots_vertical.svg',
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocBuilder<CreatorCubit, CreatorState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: AccountMediumInfo(
                      user: RepositoryProvider.of<CreatorRepository>(context)
                          .userData!),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 26),
                ),
                SliverToBoxAdapter(
                  child: CustomTextButton.withIcon(
                    callback: () {},
                    text: localizations.toWrite,
                    styleText: AppTypography.font14white,
                    active: true,
                    icon: const Icon(
                      Icons.mail_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 10),
                ),
                SliverToBoxAdapter(
                  child: CustomTextButton.withIcon(
                    callback: () {
                      launchUrl(Uri.parse(
                          'tel://${context.read<CreatorRepository>().userData!.phone}'));
                    },
                    text: localizations.toCall,
                    styleText: AppTypography.font14white,
                    active: true,
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
                AnnouncementTypeTabs(
                    tabController: _tabController,
                    onTap: (int val) {
                      setState(() {});
                    },
                    state: state),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 15,
                  ),
                ),
                if (state is CreatorSuccessState) ...[
                  buildAnnouncementsGrid(state)
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
