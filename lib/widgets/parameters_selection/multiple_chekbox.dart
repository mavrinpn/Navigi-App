import 'package:flutter/material.dart';
import 'package:smart/main.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';

class MultipleCheckboxPicker extends StatefulWidget {
  const MultipleCheckboxPicker({super.key, required this.parameter});

  final SelectParameter parameter;

  @override
  State<MultipleCheckboxPicker> createState() => _MultipleCheckboxPickerState();
}

class _MultipleCheckboxPickerState extends State<MultipleCheckboxPicker> {
  @override
  Widget build(BuildContext context) {
    final variants = widget.parameter.variants;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MyApp.getLocale(context) == 'fr' ? widget.parameter.frName : widget.parameter.arName,
            style: AppTypography.font16black.copyWith(fontSize: 18),
          ),
          ...List.generate(
              variants.length,
                  (index) => MultipleCheckboxWidget(
                  value:  MyApp.getLocale(context) == 'fr' ? variants[index].nameFr : variants[index].nameAr,
                  onTap: (bool? v) {
                    if (v ?? false) {
                      widget.parameter.addSelectedValue(variants[index]);
                    } else {
                      widget.parameter.removeSelectedValue(variants[index]);
                    }

                    setState(() {});
                  },
                  active: widget.parameter.isSelected(variants[index]))),
        ]
      ),
    );
  }
}

class MultipleCheckboxWidget extends StatelessWidget {
  const MultipleCheckboxWidget(
      {super.key,
      required this.value,
      required this.onTap,
      required this.active});

  final bool active;
  final String value;
  final Function(bool?) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 0, 5),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: active,
              onChanged: onTap,
              activeColor: AppColors.red,
            ),
          ),
          const SizedBox(width: 4,),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: AppTypography.font14black
                .copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
