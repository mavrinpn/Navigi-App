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
  const SelectMarkScreen(
      {super.key, required this.needSelectModel, required this.subcategory});

  final bool needSelectModel;
  final String subcategory;

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
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        backgroundColor: AppColors.empty,
        elevation: 0,
        title: Text(
          'Select mark',
          style: AppTypography.font20black,
        ),
      ),
      body: BlocBuilder<SelectMarkCubit, SelectMarkState>(
        builder: (context, state) {
          if (state is MarksGotState || marksPreloaded) {
            if (state is MarksGotState) marksPreloaded = true;
            print(cubit.marks.length);
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
