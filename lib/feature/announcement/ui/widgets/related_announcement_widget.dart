import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/announcement/bloc/related/related_announcement_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/conatainers/announcement.dart';

class RelatedAnnouncementWidget extends StatefulWidget {
  const RelatedAnnouncementWidget({
    super.key,
    required this.price,
    required this.subcategoryId,
    required this.parentId,
  });

  final double price;
  final String subcategoryId;
  final String parentId;

  @override
  State<RelatedAnnouncementWidget> createState() =>
      _RelatedAnnouncementWidgetState();
}

class _RelatedAnnouncementWidgetState extends State<RelatedAnnouncementWidget> {
  @override
  void initState() {
    context.read<RelatedAnnouncementCubit>().load(
          subcategoryId: widget.subcategoryId,
          minPrice: widget.price * 0.8,
          maxPrice: widget.price * 1.2,
          excludeId: widget.parentId,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RelatedAnnouncementCubit, RelatedAnnouncementState>(
      builder: (context, state) {
        if (state is RelatedAnnouncementsSuccessState) {
          if (state.announcements.isNotEmpty) {
            return Column(
              children: [
                const _Title(),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => AnnouncementContainer(
                      announcement: state.announcements[index]),
                  itemCount: state.announcements.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                    maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                    childAspectRatio: 160 / 272,
                  ),
                ),
                const SizedBox(height: 50),
              ],
            );
          } else {
            return const SizedBox(height: 100);
          }
        } else {
          return Column(
            children: [
              const _Title(),
              Center(child: AppAnimations.bouncingLine),
              const SizedBox(height: 100),
            ],
          );
        }
      },
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocalizations.of(context)!.relatedAnnouncements,
              textAlign: TextAlign.center, style: AppTypography.font20black),
          // Text(AppLocalizations.of(context)!.viewAll,
          //     style:
          //         AppTypography.font14lightGray.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}
