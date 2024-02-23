import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/auto_model/auto_models_cubit.dart';
import 'package:smart/feature/create_announcement/ui/widgets/auto_mark_widget.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/animations.dart';

import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../bloc/subcategory/subcategory_cubit.dart';

class SelectAutoModelScreen extends StatefulWidget {
  const SelectAutoModelScreen({super.key, required this.needSelectModel});

  final bool needSelectModel;

  @override
  State<SelectAutoModelScreen> createState() => _SelectAutoModelScreenState();
}

class _SelectAutoModelScreenState extends State<SelectAutoModelScreen> {
  bool marksPreloaded = false;

  @override
  void initState() {
    context.read<AutoModelsCubit>().getMarks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final cubit = BlocProvider.of<AutoModelsCubit>(context);
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
      body: BlocBuilder<AutoModelsCubit, AutoModelsState>(
        builder: (context, state) {
          if (state is MarksSuccessState || marksPreloaded) {
            if (state is MarksSuccessState) marksPreloaded = true;

            return ListView(
              children:
                  cubit.marks.map((e) => AutoMarkWidget(mark: e, needSelectModel: widget.needSelectModel,)).toList(),
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
