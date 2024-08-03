import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/announcement/bloc/creator_cubit/creator_cubit.dart';
import 'package:smart/feature/announcement/data/creator_repository.dart';
import 'package:smart/feature/announcement/ui/dialogs/creator_show_more_bottom_sheet.dart';
import 'package:smart/feature/announcement/ui/widgets/tabs.dart';
import 'package:smart/feature/messenger/chat_function.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/button/back_button.dart';

import '../../../localization/app_localizations.dart';
import '../../../widgets/accuont/account_medium_info.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../../widgets/conatainers/announcement_container.dart';

class CreatorProfileScreen extends StatefulWidget {
  const CreatorProfileScreen({super.key});

  @override
  State<CreatorProfileScreen> createState() => _CreatorProfileScreenState();
}

class _CreatorProfileScreenState extends State<CreatorProfileScreen> with SingleTickerProviderStateMixin {
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
                    announcement: _tabController.index == 0 ? state.available[index] : state.sold[index]),
              ),
            ),
            childCount: (_tabController.index == 0 ? state.available.length : state.sold.length),
          ),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: AppSizes.anouncementGridCrossSpacing,
            mainAxisSpacing: AppSizes.anouncementGridMainSpacing,
            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
            childAspectRatio: AppSizes.anouncementAspectRatio(context),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: const CustomBackButton(),
        backgroundColor: AppColors.appBarColor,
        elevation: 0,
        titleSpacing: 6,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                final userData = context.read<CreatorRepository>().userData;
                creatorShowMoreAction(
                  context: context,
                  userId: userData!.id,
                  onAction: (value) {},
                );
              },
              icon: SvgPicture.asset('Assets/icons/menu_dots_vertical.svg'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<CreatorCubit, CreatorState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: AccountMediumInfo(user: RepositoryProvider.of<CreatorRepository>(context).userData!),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 26)),
                SliverToBoxAdapter(
                  child: CustomTextButton.withIcon(
                    callback: () {
                      final userData = context.read<CreatorRepository>().userData;
                      if (userData != null) {
                        checkBlockedAndCall(
                          context: context,
                          userId: userData.id,
                          phone: userData.phone,
                        );
                      }
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
                  child: SizedBox(height: 25),
                ),
                AnnouncementTypeTabs(
                  tabController: _tabController,
                  onTap: (int val) {
                    setState(() {});
                  },
                  state: state,
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 15),
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
