import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/auto_model/auto_models_cubit.dart';
import 'package:smart/feature/create_announcement/data/models/auto_filter.dart';
import 'package:smart/feature/create_announcement/data/models/auto_marks.dart';
import 'package:smart/utils/utils.dart';

class AutoMarkWidget extends StatefulWidget {
  const AutoMarkWidget({super.key, required this.mark, required this.needSelectModel});

  final Mark mark;
  final bool needSelectModel;

  @override
  State<AutoMarkWidget> createState() => _AutoMarkWidgetState();
}

class _AutoMarkWidgetState extends State<AutoMarkWidget> {
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (!widget.needSelectModel) {
              return Navigator.pop(context, widget.mark.id);
            }

            if (!opened) {
              context.read<AutoModelsCubit>().getModels(widget.mark.id);
            }

            setState(() {
              opened = !opened;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.mark.name,
                  style: AppTypography.font16black,
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        if (opened) ...[
          BlocBuilder<AutoModelsCubit, AutoModelsState>(
              builder: (context, state) {
            if (state is ModelsSuccessState) {
              return Column(
                  children: List.generate(
                state.models.length,
                (index) => InkWell(
                  onTap: () {
                    Navigator.pop(
                        context,
                        AutoFilter(widget.mark.id, state.models[index].id,
                            state.models[index].variants, state.models[index].engines));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 28.0, right: 16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.models[index].name,
                            style: AppTypography.font16black.copyWith(fontWeight: FontWeight.w400),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        ]),
                  ),
                ),
              ));
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [AppAnimations.bouncingLine],
              );
            }
          })
        ]
      ],
    );
  }
}
