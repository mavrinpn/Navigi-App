import 'package:flutter/material.dart';
import 'package:smart/models/custom_locate.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/checkBox/custom_check_box.dart';

class CustomSingleCheckBoxes extends StatefulWidget {
  const CustomSingleCheckBoxes({
    super.key,
    required this.parameters,
    required this.onChange,
    required this.currentVariable,
  });

  final Function(CustomLocate?) onChange;
  final List<CustomLocate> parameters;
  final CustomLocate currentVariable;

  @override
  State<CustomSingleCheckBoxes> createState() => _CustomSingleCheckBoxesState();
}

class _CustomSingleCheckBoxesState extends State<CustomSingleCheckBoxes> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.parameters
          .map((e) => GestureDetector(
                onTap: () => widget.onChange(e),
                child: Row(
                  children: [
                    CustomCheckBox(
                      isActive: e.shortName == widget.currentVariable.shortName,
                      onChanged: () => widget.onChange(e),
                    ),
                    Text(
                      e.name,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: AppTypography.font14black.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
