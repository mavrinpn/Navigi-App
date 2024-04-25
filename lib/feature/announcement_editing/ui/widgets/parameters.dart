import 'package:flutter/material.dart';
import 'package:smart/feature/create_announcement/ui/widgets/select_parameter_bottom_sheet.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/models/item/static_localized_parameter.dart';
import 'package:smart/models/item/static_parameters.dart';
import 'package:smart/services/parameters_parser.dart';
import 'package:smart/widgets/parameters_selection/input_parameter_widget.dart';
import 'package:smart/widgets/parameters_selection/multiple_chekbox.dart';
import 'package:smart/widgets/parameters_selection/select_parameter_widget.dart';

class ParametersSection extends StatefulWidget {
  const ParametersSection({
    super.key,
    required this.paramaters,
    required this.staticParameters,
  });

  final List<Parameter> paramaters;
  final StaticParameters? staticParameters;

  @override
  State<ParametersSection> createState() => _ParametersSectionState();
}

class _ParametersSectionState extends State<ParametersSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget (ParametersSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadCurrentParametersValue();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.paramaters
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: buildParameter(e),
              ))
          .toList(),
    ));
  }

  // Widget buildParameter(Parameter parameter) {
  //   if (parameter is SelectParameter) {
  //     final SelectStaticParameter? current = widget.staticParameters?.parameters
  //         .where((param) => param.key == parameter.key)
  //         .firstOrNull as SelectStaticParameter?;
  //     if (current != null) {
  //       final parameterOption = ParameterOption(
  //         current.currentOption.key,
  //         nameAr: current.currentOption.nameAr,
  //         nameFr: current.currentOption.nameFr,
  //       );
  //       parameter.currentValue = parameterOption;
  //     }
  //     return SelectParameterWidget(parameter: parameter);
  //   } else if (parameter is SingleSelectParameter) {
  //     final SingleSelectStaticParameter? current = widget
  //         .staticParameters?.parameters
  //         .where((param) => param.key == parameter.key)
  //         .firstOrNull as SingleSelectStaticParameter?;
  //     if (current != null) {
  //       final parameterOption = ParameterOption(
  //         current.currentOption.key,
  //         nameAr: current.currentOption.nameAr,
  //         nameFr: current.currentOption.nameFr,
  //       );
  //       parameter.currentValue = parameterOption;
  //     }
  //     return SelectParameterWidget(parameter: parameter);
  //   } else if (parameter is MultiSelectParameter) {
  //     final MultiSelectStaticParameter? current = widget
  //         .staticParameters?.parameters
  //         .where((param) => param.key == parameter.key)
  //         .firstOrNull as MultiSelectStaticParameter?;
  //     if (current != null) {
  //       for (final selectedOption in current.currentOption) {
  //         final parameterOption = ParameterOption(
  //           selectedOption.key,
  //           nameAr: selectedOption.nameAr,
  //           nameFr: selectedOption.nameFr,
  //         );
  //         parameter.addSelectedValue(parameterOption);
  //       }
  //     }
  //     return MultipleCheckboxPicker(
  //       parameter: parameter,
  //       wrapDirection: Axis.vertical,
  //     );
  //   } else if (parameter is InputParameter) {
  //     final InputStaticParameter? current = widget.staticParameters?.parameters
  //         .where((param) => param.key == parameter.key)
  //         .firstOrNull as InputStaticParameter?;
  //     if (current != null) {
  //       parameter.value = current.value;
  //     }
  //     return Padding(
  //       padding: const EdgeInsets.only(bottom: 16.0),
  //       child: InputParameterWidget(parameter: parameter),
  //     );
  //   } else {
  //     return Container();
  //   }
  // }

  void loadCurrentParametersValue() {
    for (final parameter in widget.paramaters) {
      if (parameter is SelectParameter) {
        final SelectStaticParameter? current = widget.staticParameters?.parameters
            .where((param) => param.key == parameter.key)
            .firstOrNull as SelectStaticParameter?;
        if (current != null) {
          final parameterOption = ParameterOption(
            current.currentOption.key,
            nameAr: current.currentOption.nameAr,
            nameFr: current.currentOption.nameFr,
          );
          parameter.currentValue = parameterOption;
        }
      } else if (parameter is SingleSelectParameter) {
        final SingleSelectStaticParameter? current = widget.staticParameters?.parameters
            .where((param) => param.key == parameter.key)
            .firstOrNull as SingleSelectStaticParameter?;
        if (current != null) {
          final parameterOption = ParameterOption(
            current.currentOption.key,
            nameAr: current.currentOption.nameAr,
            nameFr: current.currentOption.nameFr,
          );
          parameter.currentValue = parameterOption;
        }
      } else if (parameter is MultiSelectParameter) {
        final MultiSelectStaticParameter? current = widget.staticParameters?.parameters
            .where((param) => param.key == parameter.key)
            .firstOrNull as MultiSelectStaticParameter?;

        if (current != null) {
          for (final selectedOption in current.currentOption) {
            final parameterOption = ParameterOption(
              selectedOption.key,
              nameAr: selectedOption.nameAr,
              nameFr: selectedOption.nameFr,
            );
            parameter.addSelectedValue(parameterOption);
          }
        }
      } else if (parameter is InputParameter) {
        final InputStaticParameter? current = widget.staticParameters?.parameters
            .where((param) => param.key == parameter.key)
            .firstOrNull as InputStaticParameter?;
        if (current != null) {
          parameter.value = current.value;
        }
      }
    }
  }

  Widget buildParameter(Parameter parameter) {
    final localizations = AppLocalizations.of(context)!;

    if (parameter is SelectParameter) {
      // final SelectStaticParameter? current = widget.staticParameters?.parameters
      //     .where((param) => param.key == parameter.key)
      //     .firstOrNull as SelectStaticParameter?;
      // if (current != null) {
      //   final parameterOption = ParameterOption(
      //     current.currentOption.key,
      //     nameAr: current.currentOption.nameAr,
      //     nameFr: current.currentOption.nameFr,
      //   );
      //   parameter.currentValue = parameterOption;
      // }
      if (parameter.variants.length > 3) {
        return SelectParameterBottomSheet(
          title: parameter.name,
          selected: parameter.currentValue.name,
          child: SelectParameterWidget(
            parameter: parameter,
            isClickable: false,
            onChange: () => setState(() {}),
          ),
        );
      } else {
        return SelectParameterWidget(
          parameter: parameter,
          isClickable: false,
          onChange: () => setState(() {}),
        );
      }
    } else if (parameter is SingleSelectParameter) {
      // final SingleSelectStaticParameter? current = widget.staticParameters?.parameters
      //     .where((param) => param.key == parameter.key)
      //     .firstOrNull as SingleSelectStaticParameter?;
      // if (current != null) {
      //   final parameterOption = ParameterOption(
      //     current.currentOption.key,
      //     nameAr: current.currentOption.nameAr,
      //     nameFr: current.currentOption.nameFr,
      //   );
      //   parameter.currentValue = parameterOption;
      // }
      if (parameter.variants.length > 3) {
        return SelectParameterBottomSheet(
          title: parameter.name,
          selected: parameter.currentValue.name,
          child: SelectParameterWidget(
            parameter: parameter,
            isClickable: false,
            onChange: () => setState(() {}),
          ),
        );
      } else {
        return SelectParameterWidget(
          parameter: parameter,
          isClickable: false,
          onChange: () => setState(() {}),
        );
      }
    } else if (parameter is MultiSelectParameter) {
      // final MultiSelectStaticParameter? current = widget.staticParameters?.parameters
      //     .where((param) => param.key == parameter.key)
      //     .firstOrNull as MultiSelectStaticParameter?;
      // if (current != null) {
      //   for (final selectedOption in current.currentOption) {
      //     final parameterOption = ParameterOption(
      //       selectedOption.key,
      //       nameAr: selectedOption.nameAr,
      //       nameFr: selectedOption.nameFr,
      //     );
      //     parameter.addSelectedValue(parameterOption);
      //   }
      // }
      String selected = localizations.notSpecified;
      if (parameter.selectedVariants.length == 1) {
        selected = parameter.selectedVariants.first.name;
      } else if (parameter.selectedVariants.length > 1) {
        selected = '${localizations.selected}: ${parameter.selectedVariants.length}';
      }

      return SelectParameterBottomSheet(
        title: parameter.name,
        selected: selected,
        child: MultipleCheckboxPicker(
          parameter: parameter,
          wrapDirection: Axis.vertical,
          onChange: () => setState(() {}),
        ),
      );
    } else if (parameter is InputParameter) {
      // final InputStaticParameter? current = widget.staticParameters?.parameters
      //     .where((param) => param.key == parameter.key)
      //     .firstOrNull as InputStaticParameter?;
      // if (current != null) {
      //   parameter.value = current.value;
      // }

      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: InputParameterWidget(parameter: parameter),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
