import 'package:flutter/material.dart';
import 'package:smart/models/sorte_types.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/checkBox/custom_check_box.dart';

import '../../models/item/item.dart';
import '../../utils/colors.dart';

class CustomDropDownSingleCheckBox extends StatefulWidget {
  const CustomDropDownSingleCheckBox(
      {super.key,
      required this.parameters,
      required this.onChange,
      required this.currentVariable});

  final Function(String?) onChange;
  final Parameter parameters;
  final String currentVariable;

  @override
  State<CustomDropDownSingleCheckBox> createState() =>
      _CustomDropDownSingleCheckBoxState();
}

class _CustomDropDownSingleCheckBoxState
    extends State<CustomDropDownSingleCheckBox> {
  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: AnimatedContainer(
        height: isOpen ? 36.5 * (widget.parameters.variants.length + 1) : 25,
        duration: const Duration(milliseconds: 100),
        child: SingleChildScrollView(
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
                    widget.parameters.key,
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
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.parameters.variants
                      .map((e) => Row(
                            children: [
                              CustomCheckBox(
                                  isActive: e.toString() == widget.currentVariable,
                                  onChanged: () {
                                    widget.onChange(e.toString());
                                  }),
                              Text(
                                e.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: AppTypography.font14black
                                    .copyWith(fontSize: 16),
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
            ]
          ]),
        ),
      ),
    );
  }
}
