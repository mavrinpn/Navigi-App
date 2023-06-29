import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/checkBox/custom_check_box.dart';

import '../../feature/create/data/creting_announcement_manager.dart';
import '../../models/variable_paramets.dart';
import '../../utils/colors.dart';

class CustomDropDownSingleCheckBox extends StatefulWidget {
  const CustomDropDownSingleCheckBox({super.key, required this.paramets});

  final VariableParameters paramets;

  @override
  State<CustomDropDownSingleCheckBox> createState() =>
      _CustomDropDownSingleCheckBoxState();
}

class _CustomDropDownSingleCheckBoxState
    extends State<CustomDropDownSingleCheckBox> {
  bool isOpen = false;

  String currentVariable = '';

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: Column(children: [
        InkWell(
          onTap: () {
            isOpen = !isOpen;
            setState(() {});
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.paramets.key,
                style: AppTypography.font16black.copyWith(fontSize: 18),
              ),
              !isOpen
                  ? const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 16,
                      color: AppColors.lightGray,
                    )
                  : const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: AppColors.lightGray,
                    )
            ],
          ),
        ),
        if (isOpen) ...[
          Column(
                children: widget.paramets.variants.map((e) => Row(
                  children: [
                    CustomCheckBox(
                        isActive: e.toString() == currentVariable,
                        onChanged: () {
                          currentVariable = e.toString();
                          setState(() {});
                        }),
                    Text(
                      e.toString(),
                      style:
                      AppTypography.font14black.copyWith(fontSize: 16),
                    ),
                  ],
                )).toList(),
              ),
        ]
      ]),
    );
  }
}
