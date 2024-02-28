import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/marks/select_mark_cubit.dart';
import 'package:smart/feature/create_announcement/data/models/auto_marks.dart';
import 'package:smart/feature/create_announcement/data/models/marks_filter.dart';
import 'package:smart/utils/utils.dart';

class MarkWidget extends StatefulWidget {
  const MarkWidget(
      {super.key,
      required this.mark,
      required this.needSelectModel,
      required this.subcategory});

  final Mark mark;
  final bool needSelectModel;
  final String subcategory;

  @override
  State<MarkWidget> createState() => _MarkWidgetState();
}

class _MarkWidgetState extends State<MarkWidget> {
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    // print('rebuild with $opened on widget ${widget.mark.name}');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (!widget.needSelectModel) {
              return Navigator.pop(
                  context, MarksFilter(markId: widget.mark.id));
            }

            if (!opened) {
              context.read<SelectMarkCubit>().getModels(
                    widget.subcategory,
                    widget.mark.id,
                  );
            }

            setState(() {
              opened = !opened;
              // print('set opened to $opened on widget ${widget.mark.id}');
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
          BlocBuilder<SelectMarkCubit, SelectMarkState>(
              builder: (context, state) {
            if (state is ModelsLoadingState) {
              if (state.markId != widget.mark.id) {
                opened = false;
              }
            }

            if (state is ModelsGotState) {
              // print('models length: ${state.models.length}');
              if (state.models.isNotEmpty) {
                return Column(
                    children: List.generate(
                  state.models.length,
                  (index) => InkWell(
                    onTap: () {
                      Navigator.pop(
                          context,
                          MarksFilter(
                              markId: widget.mark.id,
                              modelId: state.models[index].id));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.models[index].name,
                              style: AppTypography.font16black
                                  .copyWith(fontWeight: FontWeight.w400),
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
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('nothing')],
                );
              }
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
