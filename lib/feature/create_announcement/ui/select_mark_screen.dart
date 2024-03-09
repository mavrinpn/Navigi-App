import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/marks/select_mark_cubit.dart';
import 'package:smart/feature/create_announcement/ui/widgets/mark_widget.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/animations.dart';

import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../bloc/subcategory/subcategory_cubit.dart';

class SelectMarkScreen extends StatefulWidget {
  const SelectMarkScreen({
    super.key,
    required this.needSelectModel,
    required this.subcategory,
    this.isBottomSheet = false,
  });

  final bool needSelectModel;
  final String subcategory;
  final bool isBottomSheet;

  @override
  State<SelectMarkScreen> createState() => _SelectMarkScreenState();
}

class _SelectMarkScreenState extends State<SelectMarkScreen> {
  bool marksPreloaded = false;

  @override
  void initState() {
    context.read<SelectMarkCubit>().getMarks(widget.subcategory);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final cubit = BlocProvider.of<SelectMarkCubit>(context);

    return Scaffold(
      appBar: widget.isBottomSheet
          ? AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 70,
              flexibleSpace: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 120,
                      height: 4,
                      decoration: ShapeDecoration(
                          color: const Color(0xFFDDE1E7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1))),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      localizations.choosingMark,
                      style: AppTypography.font20black,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            )
          : AppBar(
              iconTheme: const IconThemeData.fallback(),
              backgroundColor: AppColors.empty,
              elevation: 0,
              title: Text(
                localizations.choosingMark,
                style: AppTypography.font20black,
              ),
            ),
      body: BlocBuilder<SelectMarkCubit, SelectMarkState>(
        builder: (context, state) {
          if (state is MarksGotState || marksPreloaded) {
            if (state is MarksGotState) marksPreloaded = true;

            return ListView(
              children: cubit.marks
                  .map((e) => MarkWidget(
                        mark: e,
                        needSelectModel: widget.needSelectModel,
                        subcategory: widget.subcategory,
                      ))
                  .toList(),
            );
          } else if (state is SubcategoryFailState) {
            return Center(
              child: Text(localizations.errorReviewOrEnterOther),
            );
          } else {
            return Center(child: AppAnimations.bouncingLine);
          }
        },
      ),
    );
  }
}
