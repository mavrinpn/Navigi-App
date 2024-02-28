import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/car_model/car_models_cubit.dart';
import 'package:smart/feature/create_announcement/ui/widgets/car_mark_widget.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/animations.dart';

import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../bloc/subcategory/subcategory_cubit.dart';

class SelectCarModelScreen extends StatefulWidget {
  const SelectCarModelScreen({super.key, required this.needSelectModel});

  final bool needSelectModel;

  @override
  State<SelectCarModelScreen> createState() => _SelectCarModelScreenState();
}

class _SelectCarModelScreenState extends State<SelectCarModelScreen> {
  bool marksPreloaded = false;

  @override
  void initState() {
    context.read<CarModelsCubit>().getMarks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final cubit = BlocProvider.of<CarModelsCubit>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        backgroundColor: AppColors.empty,
        elevation: 0,
        title: Text(
          'Select mark', //TODO localize
          style: AppTypography.font20black,
        ),
      ),
      body: BlocBuilder<CarModelsCubit, CarModelsState>(
        builder: (context, state) {
          if (state is MarksSuccessState || marksPreloaded) {
            if (state is MarksSuccessState) marksPreloaded = true;

            return ListView(
              children: cubit.marks
                  .map((e) => CarMarkWidget(
                        mark: e,
                        needSelectModel: widget.needSelectModel,
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
