import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/marks/select_mark_cubit.dart';
import 'package:smart/feature/create_announcement/data/models/marks_filter.dart';
import 'package:smart/feature/create_announcement/ui/widgets/appbar_bottom_searchbar.dart';
import 'package:smart/feature/create_announcement/ui/widgets/mark_widget.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

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
  String _searchString = '';
  MarksFilter? _marksFilter;

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
              backgroundColor: AppColors.appBarColor,
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))),
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
              bottom: AppBarBottomSearchbar(onChange: _onSearchBarChanged),
            )
          : AppBar(
              iconTheme: const IconThemeData.fallback(),
              backgroundColor: AppColors.appBarColor,
              elevation: 0,
              title: Text(
                localizations.choosingMark,
                style: AppTypography.font20black,
              ),
              bottom: AppBarBottomSearchbar(onChange: _onSearchBarChanged),
            ),
      body: BlocBuilder<SelectMarkCubit, SelectMarkState>(
        builder: (context, state) {
          if (state is MarksGotState || marksPreloaded) {
            if (state is MarksGotState) marksPreloaded = true;

            return ListView(
              children: cubit.marks
                  .where((element) => element.name.toLowerCase().startsWith(_searchString))
                  .map((mark) => MarkWidget(
                        mark: mark,
                        needSelectModel: widget.needSelectModel,
                        subcategory: widget.subcategory,
                        onModelSelected: (model) {
                          _marksFilter = MarksFilter(
                            markId: mark.id,
                            modelId: model.id,
                            markTitle: mark.name,
                            modelTitle: model.name,
                          );
                          setState(() {});
                        },
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
      floatingActionButton: _marksFilter != null
          ? CustomTextButton.orangeContinue(
              width: MediaQuery.of(context).size.width - 30,
              text: localizations.done,
              callback: () {
                Navigator.pop(context, [_marksFilter]);
              },
              active: true,
            )
          : null,
    );
  }

  void _onSearchBarChanged(String value) {
    setState(() {
      _searchString = value;
    });
  }
}
