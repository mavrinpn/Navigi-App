import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/bloc/car_model/car_models_cubit.dart';
import 'package:smart/feature/create_announcement/data/models/car_model.dart';
import 'package:smart/feature/create_announcement/data/models/mark.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/checkBox/custom_check_box.dart';

class CarMarkWidget extends StatefulWidget {
  const CarMarkWidget({
    super.key,
    required this.mark,
    required this.subcategory,
    required this.needSelectModel,
    required this.onModelSelected,
  });

  final Mark mark;
  final String subcategory;
  final bool needSelectModel;
  final Function(CarModel) onModelSelected;

  @override
  State<CarMarkWidget> createState() => _CarMarkWidgetState();
}

class _CarMarkWidgetState extends State<CarMarkWidget> {
  bool opened = false;
  String _selectedModelId = '';

  @override
  Widget build(BuildContext context) {
    final url = widget.mark.image?.trim().replaceAll('\r', '').replaceAll('\n', '');

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
                      ? CachedNetworkImage(
                          imageUrl: url,
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          placeholderFadeInDuration: Duration.zero,
                          errorWidget: (context, error, stackTrace) {
                            return Container();
                          },
                        )
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
                RotatedBox(
                  quarterTurns: opened ? 1 : 0,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                )
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
                    onTap: () => _onModelSelected(state.models[index]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 16),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        CustomCheckBox(
                          isActive: state.models[index].id == _selectedModelId,
                          onChanged: () => _onModelSelected(state.models[index]),
                        ),
                        Expanded(
                          child: Text(
                            state.models[index].name,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.font16black.copyWith(fontWeight: FontWeight.w400),
                          ),
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
            },
          ),
        ]
      ],
    );
  }

  void _onModelSelected(CarModel model) {
    widget.onModelSelected(model);
    setState(() {
      _selectedModelId = model.id;
    });
  }
}
