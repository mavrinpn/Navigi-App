import 'package:flutter/material.dart';
import 'package:smart/feature/search/ui/bottom_sheets/filter_bottom_sheet_dialog.dart';

class FilterChipWidget extends StatelessWidget {
  const FilterChipWidget({
    super.key,
    required this.isSelected,
    required this.title,
    required this.parameterKey,
  });

  final bool isSelected;
  final String title;
  final String parameterKey;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isSelected ? Colors.white : Colors.black;

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(color: foregroundColor),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: foregroundColor,
          )
        ],
      ),
      onSelected: (value) {
        showFilterBottomSheet(
          context: context,
          parameterKey: parameterKey,
        );
      },
    );
  }
}
