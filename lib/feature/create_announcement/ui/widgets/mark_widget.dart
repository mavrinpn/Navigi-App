import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/marks/select_mark_cubit.dart';
import 'package:smart/feature/create_announcement/data/models/mark.dart';
import 'package:smart/feature/create_announcement/data/models/marks_filter.dart';
import 'package:smart/utils/utils.dart';

class MarkWidget extends StatefulWidget {
  const MarkWidget({
    super.key,
    required this.mark,
    required this.needSelectModel,
    required this.subcategory,
  });

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
    // final updateAppBarFilterCubit = context.read<UpdateAppBarFilterCubit>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (!widget.needSelectModel) {
              // updateAppBarFilterCubit.needUpdateAppBarFilters();
              Navigator.pop(
                context,
                [
                  MarksFilter(
                    markId: widget.mark.id,
                    markTitle: widget.mark.name,
                    modelTitle: '',
                  )
                ],
              );
            }

            if (!opened) {
              context.read<SelectMarkCubit>().getModels(
                    widget.subcategory,
                    widget.mark.id,
                  );
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
                Expanded(
                  child: Text(
                    widget.mark.name,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.font16black,
                  ),
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
              if (state.models.isNotEmpty) {
                return Column(
                    children: List.generate(
                  state.models.length,
                  (index) => InkWell(
                    onTap: () {
                      // updateAppBarFilterCubit.needUpdateAppBarFilters();
                      Navigator.pop(context, [
                        MarksFilter(
                          markId: widget.mark.id,
                          modelId: state.models[index].id,
                          markTitle: widget.mark.name,
                          modelTitle: state.models[index].name,
                        ),
                      ]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              state.models[index].name,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.font16black
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        ],
                      ),
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
