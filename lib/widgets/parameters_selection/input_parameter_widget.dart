import 'package:flutter/material.dart';
import 'package:smart/main.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/widgets/textField/outline_text_field.dart';

class InputParameterWidget extends StatefulWidget {
  const InputParameterWidget({super.key, required this.parameter});

  final InputParameter parameter;

  @override
  State<InputParameterWidget> createState() => _InputParameterWidgetState();
}

class _InputParameterWidgetState extends State<InputParameterWidget> {
  final controller = TextEditingController();

  bool error = false;

  @override
  Widget build(BuildContext context) {
    return OutLineTextField(
      hintText: MyApp.getLocale(context) == 'fr'
          ? widget.parameter.frName
          : widget.parameter.arName,
      controller: controller,
      width: double.infinity,
      maxLength: 100,
      error: error,
      onChange: (value) {
        if (value.isNotEmpty) {
          final type = widget.parameter.type;
          final dynamic typedValue;
          switch (type) {
            case 'int':
              typedValue = int.tryParse(value);
            case 'double':
              typedValue = double.tryParse(value);
            default:
              typedValue = value;
          }
          if (typedValue == null) {
            setState(() {
              error = true;
            });
          } else {
            widget.parameter.value = typedValue;
            setState(() {
              error = false;
            });
          }
        }
      },
    );
  }
}
