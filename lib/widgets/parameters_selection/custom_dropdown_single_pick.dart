import 'package:flutter/material.dart';
import 'package:smart/main.dart';
import 'package:smart/services/parameters_parser.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/checkBox/custom_check_box.dart';
import 'package:smart/widgets/parameters_selection/single_pick_with_search.dart';

import '../../models/item/item.dart';
import '../../utils/colors.dart';

class CustomDropDownSingleCheckBox extends StatefulWidget {
  const CustomDropDownSingleCheckBox({super.key,
    required this.parameter,
    required this.onChange,
    required this.currentVariable,
    this.useLocalizationKeys = false});

  final Function(ParameterOption) onChange;
  final SelectParameter parameter;
  final dynamic currentVariable;

  final bool useLocalizationKeys;

  @override
  State<CustomDropDownSingleCheckBox> createState() =>
      _CustomDropDownSingleCheckBoxState();
}

class _CustomDropDownSingleCheckBoxState
    extends State<CustomDropDownSingleCheckBox> {
  bool isOpen = true;
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final currentLocale = MyApp.getLocale(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: AnimatedContainer(
        height: isOpen ? 36.5 * (widget.parameter.variants.length + 1) : 25,
        duration: const Duration(milliseconds: 100),
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
                  currentLocale == 'fr' ? widget.parameter.frName : widget.parameter.arName,
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
            !showAll
                ? buildSimplePicker()
                : SinglePickWithSearch(parameter: widget.parameter)
          ]
        ]),
      ),
    );
  }

  Widget buildSimplePicker() {
    int maximum = 0;

    if (widget.parameter.variants.length < 7) {
      maximum = widget.parameter.variants.length;
    } else {
      maximum = 7;
    }

    print('Current locale: ${MyApp.getLocale(context)}');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...(widget.parameter.variants.sublist(0, maximum))
              .map((e) =>
              Row(
                children: [
                  CustomCheckBox(
                      isActive: e == widget.currentVariable,
                      onChanged: () {
                        widget.onChange(e);
                      }),
                  Text(
                    MyApp.getLocale(context) == 'fr' ? e.nameFr : e.nameAr,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: AppTypography.font14black
                        .copyWith(fontSize: 16),
                  ),
                ],
              ))
              .toList(),
          if (widget.parameter.variants.length > 7) ...[
            GestureDetector(
              onTap: () {
                setState(() {
                  showAll = true;
                });
              },
              child: Text(
                'show more',
                style: AppTypography.font12lightGray,
              ),
            )
          ]
        ],
      ),
    );
  }
}
