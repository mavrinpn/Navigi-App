import 'package:flutter/material.dart';
import 'package:smart/feature/announcement_editing/bloc/announcement_edit_cubit.dart';
import 'package:smart/widgets/parameters_selection/custom_dropdown_single_pick.dart';

class ParametersSection extends StatelessWidget {
  const ParametersSection({super.key, required this.cubit});

  final AnnouncementEditCubit cubit;

  Widget getParameters() {
    try {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: (cubit.data.parameters != null
            ? []
            : [])
            .map((e) =>
            CustomDropDownSingleCheckBox(
              parameter: e,
              onChange: (value) {
                cubit.setParameterValue(e.key, value);
              },
              currentVariable: e.currentValue,
            ))
            .toList(),
      );
    } catch (e) {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: getParameters()
    );
  }
}
