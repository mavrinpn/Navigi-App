import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.paramaters.map((e) => buildParameter(e)).toList(),
    ));
  }

  Widget buildParameter(Parameter parameter) {
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
      return SelectParameterWidget(parameter: parameter);
    } else if (parameter is MultiSelectParameter) {
      final MultiSelectStaticParameter? current = widget
          .staticParameters?.parameters
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

      return MultipleCheckboxPicker(
        parameter: parameter,
        wrapDirection: Axis.vertical,
      );
    } else if (parameter is InputParameter) {
      final InputStaticParameter? current = widget.staticParameters?.parameters
          .where((param) => param.key == parameter.key)
          .firstOrNull as InputStaticParameter?;
      if (current != null) {
        parameter.value = current.value;
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: InputParameterWidget(parameter: parameter),
      );
    } else {
      return Container();
    }
  }
}
