import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/announcement/bloc/related/related_announcement_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/models/item/static_localized_parameter.dart';
import 'package:smart/models/item/static_parameters.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/conatainers/announcement_container.dart';

class RelatedAnnouncementWidget extends StatefulWidget {
  const RelatedAnnouncementWidget({
    super.key,
    required this.price,
    required this.subcategoryId,
    required this.parentId,
    required this.model,
    required this.staticParameters,
  });

  final double price;
  final String subcategoryId;
  final String parentId;
  final String model;
  final StaticParameters staticParameters;

  @override
  State<RelatedAnnouncementWidget> createState() => _RelatedAnnouncementWidgetState();
}

class _RelatedAnnouncementWidgetState extends State<RelatedAnnouncementWidget> {
  @override
  void initState() {
    String type = '';
    final typeParams = widget.staticParameters.parameters.where(
      (element) => element.key == 'type',
    );
    if (typeParams.isNotEmpty) {
      final typeParam = typeParams.first as SingleSelectStaticParameter;
      type = typeParam.currentOption.key;
    }

    context.read<RelatedAnnouncementCubit>().load(
          subcategoryId: widget.subcategoryId,
          minPrice: widget.price * 0.8,
          maxPrice: widget.price * 1.2,
          excludeId: widget.parentId,
          model: widget.model,
          type: type,
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
                  itemBuilder: (context, index) => AnnouncementContainer(announcement: state.announcements[index]),
                  itemCount: state.announcements.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
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
