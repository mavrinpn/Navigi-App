import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/search/bloc/update_appbar_filter/update_appbar_filter_cubit.dart';
import 'package:smart/main.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';

class MultipleCheckboxPicker extends StatefulWidget {
  const MultipleCheckboxPicker({
    super.key,
    required this.parameter,
    required this.wrapDirection,
    required this.onChange,
  });

  final dynamic parameter;
  final Axis wrapDirection;
  final Function onChange;

  @override
  State<MultipleCheckboxPicker> createState() => _MultipleCheckboxPickerState();
}

class _MultipleCheckboxPickerState extends State<MultipleCheckboxPicker> {
  @override
  Widget build(BuildContext context) {
    final variants = widget.parameter.variants;

    final updateAppBarFilterCubit = context.read<UpdateAppBarFilterCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.parameter.name,
            style: AppTypography.font16black.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            direction: widget.wrapDirection,
            children: [
              ...List.generate(
                variants.length,
                (index) => MultipleCheckboxWidget(
                  value: MyApp.getLocale(context) == 'fr' ? variants[index].nameFr : variants[index].nameAr,
                  onTap: (bool? v) {
                    updateAppBarFilterCubit.needUpdateAppBarFilters();
                    if (v ?? false) {
                      widget.parameter.addSelectedValue(variants[index]);
                    } else {
                      widget.parameter.removeSelectedValue(variants[index]);
                    }

                    setState(() {});
                    widget.onChange();
                  },
                  active: widget.parameter.isSelected(
                    variants[index],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MultipleCheckboxWidget extends StatelessWidget {
  const MultipleCheckboxWidget({
    super.key,
    required this.value,
    required this.onTap,
    required this.active,
  });

  final bool active;
  final String value;
  final Function(bool?) onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: InkWell(
        onTap: () {
          onTap(!active);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: active,
                  onChanged: onTap,
                  activeColor: AppColors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  side: WidgetStateBorderSide.resolveWith(
                    (states) => BorderSide(
                      width: 1,
                      color: active ? AppColors.red : AppColors.radioButtonGray,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: AppTypography.font14black.copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
