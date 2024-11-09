import 'package:flutter/material.dart';
import 'package:smart/main.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/widgets/textField/outline_text_field.dart';

class InputParameterWidget extends StatefulWidget {
  const InputParameterWidget({
    super.key,
    required this.parameter,
    this.onChange,
    this.validator,
  });

  final InputParameter parameter;
  final String? Function(String?)? validator;
  final Function? onChange;

  @override
  State<InputParameterWidget> createState() => _InputParameterWidgetState();
}

class _InputParameterWidgetState extends State<InputParameterWidget> {
  late final controller = TextEditingController();
  bool error = false;

  // @override
  // void didUpdateWidget(covariant InputParameterWidget oldWidget) {
  //   controller.text = '${widget.parameter.value ?? ''}';
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void initState() {
    super.initState();
    controller.text = '${widget.parameter.value ?? ''}';
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.parameter.type;
    final keyBoardType = ['int', 'double'].contains(type) ? TextInputType.number : TextInputType.text;

    return OutlineTextField(
      hintText: MyApp.getLocale(context) == 'fr' ? widget.parameter.frName : widget.parameter.arName,
      controller: controller,
      keyBoardType: keyBoardType,
      width: double.infinity,
      maxLength: 100,
      error: error,
      validator: widget.validator,
      onChange: (value) {
        widget.onChange?.call();
        if (value.isNotEmpty) {
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
