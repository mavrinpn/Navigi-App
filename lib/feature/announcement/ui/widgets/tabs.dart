import 'package:flutter/material.dart';
import 'package:smart/feature/announcement/bloc/creator_cubit/creator_cubit.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';

class AnnouncementTypeTabs extends StatelessWidget {
  const AnnouncementTypeTabs(
      {super.key,
      required this.tabController,
      required this.onTap,
      required this.state});

  final TabController tabController;
  final Function(int) onTap;
  final CreatorState state;

  @override
  Widget build(BuildContext context) {
    int available = 0;
    int sold = 0;
    if (state is CreatorSuccessState) {
      available = (state as CreatorSuccessState).available.length;
      sold = (state as CreatorSuccessState).sold.length;
    }

    return SliverToBoxAdapter(
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
                borderSide: BorderSide(color: AppColors.red, width: 2),
                insets: EdgeInsets.symmetric(horizontal: 20)),
            onTap: onTap,
            controller: tabController,
            tabs: [
              Tab(
                child: Text('Actif ($available)',
                    style: AppTypography.font24black.copyWith(
                        fontSize: 14,
                        color: tabController.index == 0
                            ? Colors.black
                            : Colors.grey)),
              ),
              Tab(
                child: Text('Vendu ($sold)',
                    style: AppTypography.font24black.copyWith(
                        fontSize: 14,
                        color: tabController.index == 1
                            ? Colors.black
                            : Colors.grey)),
              ),
            ],
          )),
    );
  }
}
