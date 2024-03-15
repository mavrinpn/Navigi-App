import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/car_model/car_models_cubit.dart';
import 'package:smart/feature/create_announcement/data/models/car_filter.dart';
import 'package:smart/feature/create_announcement/data/models/mark.dart';
import 'package:smart/utils/utils.dart';

class CarMarkWidget extends StatefulWidget {
  const CarMarkWidget({
    super.key,
    required this.mark,
    required this.subcategory,
    required this.needSelectModel,
  });

  final Mark mark;
  final String subcategory;
  final bool needSelectModel;

  @override
  State<CarMarkWidget> createState() => _CarMarkWidgetState();
}

class _CarMarkWidgetState extends State<CarMarkWidget> {
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    final url =
        widget.mark.image?.trim().replaceAll('\r', '').replaceAll('\n', '');

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
              context.read<CarModelsCubit>().getModels(
                    subcategory: widget.subcategory,
                    mark: widget.mark.id,
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
                SizedBox(
                  height: 24,
                  width: 28,
                  child: url != null
                      ? Image.network(
                          url,
                          errorBuilder: (context, error, stackTrace) {
                            return Container();
                          },
                        )
                      // ? CachedNetworkImage( //TODO CachedNetworkImage
                      //     imageUrl:
                      //         widget.mark.image!.trim().replaceAll('\r', ''),
                      //     errorWidget: (context, error, stackTrace) {
                      //       return Container();
                      //     },
                      //   )
                      : Container(),
                ),
                const SizedBox(width: 6),
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
          BlocBuilder<CarModelsCubit, CarModelsState>(
              builder: (context, state) {
            if (state is ModelsLoadingState) {
              if (state.markId != widget.mark.id) {
                opened = false;
              }
            }
            if (state is ModelsSuccessState) {
              return Column(
                  children: List.generate(
                state.models.length,
                (index) => InkWell(
                  onTap: () {
                    final filter = CarFilter(
                      markId: widget.mark.id,
                      modelId: state.models[index].id,
                      markTitle: widget.mark.name,
                      modelTitle: state.models[index].name,
                      stringDotations: state.models[index].variants,
                      stringEngines: state.models[index].engines,
                    );
                    Navigator.pop(context, filter);
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
