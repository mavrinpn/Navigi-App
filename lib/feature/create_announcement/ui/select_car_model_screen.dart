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
  const SelectCarModelScreen({
    super.key,
    required this.needSelectModel,
    required this.subcategory,
    this.isBottomSheet = false,
  });

  final bool needSelectModel;
  final String subcategory;
  final bool isBottomSheet;

  @override
  State<SelectCarModelScreen> createState() => _SelectCarModelScreenState();
}

class _SelectCarModelScreenState extends State<SelectCarModelScreen> {
  bool marksPreloaded = false;

  @override
  void initState() {
    context.read<CarModelsCubit>().getMarks(widget.subcategory);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final cubit = BlocProvider.of<CarModelsCubit>(context);

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
                      localizations.choosingCarBrand,
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
                localizations.choosingCarBrand,
                style: AppTypography.font20black,
              ),
            ),
      body: BlocBuilder<CarModelsCubit, CarModelsState>(
        builder: (context, state) {
          if (state is MarksSuccessState || marksPreloaded) {
            if (state is MarksSuccessState) marksPreloaded = true;

            return ListView(
              children: cubit.marks
                  .map(
                    (mark) => CarMarkWidget(
                      mark: mark,
                      subcategory: widget.subcategory,
                      needSelectModel: widget.needSelectModel,
                    ),
                  )
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
